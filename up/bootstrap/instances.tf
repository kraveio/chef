
# CHEF
# m3.large (2cpu, 7.5gb) is probably the ideal size or c3.xlarge (4cpu, 7.5gb)
#
resource "aws_instance" "chef" {
	depends_on = ["aws_instance.nat", "aws_instance.jump", "aws_route_table.nat"]
	instance_type = "m3.medium"
	private_ip = "10.0.10.7"
	subnet_id = "${aws_subnet.admin.id}"
	iam_instance_profile = "chef"
	security_groups = ["${aws_security_group.ssh_base.id}", "${aws_security_group.chef.id}"]
	ami = "${var.chef_ami}"
	availability_zone = "${var.zone_default}"
	key_name = "${var.key_name}"
	source_dest_check = true

	root_block_device {
		delete_on_termination = true
	}
	tags {
		Name = "chef-01"
	}

	# wait until server is up
	provisioner "local-exec" {
		command = "sleep ${var.sleep_seconds}" #it takes a little while for the server to come up
	}

	# create tunnel on 12022 to chef 
	provisioner "local-exec" {
		command = "ssh -f -L 12022:${self.private_ip}:22 ec2-user@${aws_instance.jump.public_ip} -o StrictHostKeyChecking=no sleep ${var.ssh_wait_seconds} <&- >&- 2>&- &"
	}

	connection {
		user = "ubuntu"
		agent = true
		port = 12022
		host = "127.0.0.1"
	}

	provisioner "remote-exec" {
		inline = [
			"sudo apt-get update"
		]
	}

	provisioner "file" {
		source = "${path.module}/bootstrap-chef-server.sh"
		destination = "~/bootstrap-chef-server.sh"
    }

	provisioner "remote-exec" {
		inline = [
			"chmod 774 bootstrap-chef-server.sh", # make executable
			"sudo ~/bootstrap-chef-server.sh"
		]
	}
}

#resource "aws_eip" "jump" {
#    instance = "${aws_instance.jump.id}"
#    vpc = true
#}


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

	provisioner "local-exec" {
        command = "echo ${self.public_ip} >> jump_ips.txt"
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
#		volume_size = ""
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


