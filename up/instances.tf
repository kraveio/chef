
# CHEF
# m3.large (2cpu, 7.5gb) is probably the ideal size or c3.xlarge (4cpu, 7.5gb)
#
resource "aws_instance" "chef" {
	depends_on = ["aws_instance.jump"]
	instance_type = "m3.medium"
	private_ip = "10.0.10.7"
	subnet_id = "${aws_subnet.admin.id}"
	iam_instance_profile = "chef"
	security_groups = ["${aws_security_group.ssh_base.id}", "${aws_security_group.chef.id}"]
	ami = "${lookup(var.amis, var.region)}"
	availability_zone = "${var.zone_default}"
	key_name = "${var.key_name}"
	root_block_device {
#		volume_size = ""
		delete_on_termination = true
	}
	tags {
		Name = "chef-01"
	}

#	provisioner "remote-exec" {
#		inline = [
#			"echo test"
#		]
#		connection {
#			host = "${aws_instance.jump.public_ip}"
#			user = "ec2-user"
#			agent = true
#		}
#	}

	# create tunnel on 12022 to chef 
	provisioner "local-exec" {
		command = "ssh -f -L 12022:${self.private_ip}:22 ec2-user@${aws_instance.jump.public_ip} -o StrictHostKeyChecking=no sleep 300 <&- >&- 2>&- &"
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
		source = "./bootstrap-chef.sh"
		destination = "~/bootstrap-chef.sh"
    }

	provisioner "remote-exec" {
		script = "./bootstrap-chef.sh"
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


