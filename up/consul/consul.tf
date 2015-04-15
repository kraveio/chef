resource "aws_instance" "consul" {
	instance_type = "m3.medium"
	private_ip = "10.0.100.7"
	subnet_id = "${aws_subnet.consul.id}"
	# iam_instance_profile = "consul"
	security_groups = ["${aws_security_group.ssh_base.id}", "${aws_security_group.consul.id}"]

	ami = "${var.ami}"
	availability_zone = "${var.zone_default}"
	key_name = "${var.key_name}"
	source_dest_check = true

	root_block_device {
		delete_on_termination = false
	}

	##TODO: Need more storage

	tags {
		Name = "consul-01"
	}

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
		source = "./bootstrap-chef-server.sh"
		destination = "~/bootstrap-chef-server.sh"
    }

	provisioner "remote-exec" {
		script = "sudo ./bootstrap-chef-server.sh"
	}
}

