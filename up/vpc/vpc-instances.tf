
resource "aws_instance" "provision" {
	instance_type = "t2.small"
	private_ip = "10.0.98.7"
	subnet_id = "${aws_subnet.admin.id}"
	security_groups = ["${aws_security_group.jump.id}"]
	ami = "${lookup(var.ubuntu_amis, var.region)}"
	availability_zone = "${var.zone_default}"
	source_dest_check = true
	
	# TODO use different jump key
	key_name = "${var.key_name}" 

	root_block_device {
		delete_on_termination = true
	}

	tags {
		Name = "provision"
	}

	# wait until jump server is up
	provisioner "local-exec" {
		command = "sleep ${var.sleep_seconds}" #it takes a little while for the server to come up
	}

	# create tunnel on 12023 
	provisioner "local-exec" {
		command = "ssh -f -L 12023:${self.private_ip}:22 ec2-user@${aws_instance.jump.public_ip} -o StrictHostKeyChecking=no sleep ${var.ssh_wait_seconds} <&- >&- 2>&- &"
	}

	connection {
		user = "ubuntu"
		agent = true
		port = 12023
		host = "127.0.0.1"
	}

	provisioner "file" {
		source = "${var.aws_key_path}"
		destination = "~/.ssh/current"
    }

	provisioner "remote-exec" {
		inline = [
			"chmod 600 ~/.ssh/current",
			"sudo apt-get install software-properties-common",
			"sudo apt-add-repository ppa:ansible/ansible",
			"sudo apt-get update",
			"sudo apt-get install ansible"
		]
	}
}

resource "aws_instance" "jump" {
	instance_type = "t2.micro"
	private_ip = "10.0.0.7"
	subnet_id = "${aws_subnet.dmz.id}"
	security_groups = ["${aws_security_group.jump.id}"]
	ami = "${lookup(var.jump_amis, var.region)}"
	availability_zone = "${var.zone_default}"
	source_dest_check = true
	
	# TODO use different jump key
	key_name = "${var.key_name}" 

	root_block_device {
		delete_on_termination = true
	}
	tags {
		Name = "jump"
	}

	connection {
		user = "ec2-user"
		agent = true
	}

	provisioner "local-exec" {
		command = "sleep ${var.sleep_seconds}" #it takes a little while for the server to come up
	}

	provisioner "remote-exec" {
		inline = [
			"sudo yum update -y"
		]
	}

	provisioner "file" {
		source = "${var.aws_key_path}"
		destination = "~/.ssh/current"
    }

	provisioner "remote-exec" {
		inline = [
			"chmod 600 ~/.ssh/current"
		]
	}
}

############################
# NAT Instance
############################

resource "aws_instance" "nat" {
	instance_type = "m1.small"
	private_ip = "10.0.0.250"
	source_dest_check = false				#important for nat
	subnet_id = "${aws_subnet.dmz.id}"
	security_groups = ["${aws_security_group.nat.id}"]
	ami = "${lookup(var.nat_amis, var.region)}"
	availability_zone = "${var.zone_default}"
	key_name = "${var.key_name}"
	root_block_device {
		delete_on_termination = true
	}
	tags {
		Name = "nat"
	}

	# wait until jump server is up
	provisioner "local-exec" {
		command = "sleep ${var.sleep_seconds}" #it takes a little while for the server to come up
	}

	# create tunnel on 12023 to chef
	provisioner "local-exec" {
		command = "ssh -f -L 12023:${self.private_ip}:22 ec2-user@${aws_instance.jump.public_ip} -o StrictHostKeyChecking=no sleep ${var.ssh_wait_seconds} <&- >&- 2>&- &"
	}

	connection {
		user = "ec2-user"
		agent = true
		port = 12023
		host = "127.0.0.1"
	}

	provisioner "remote-exec" {
		inline = [
			"sudo yum update -y"
		]
	}
}

