provider "aws" {
	access_key = "${var.access_key}"
	secret_key = "${var.secret_key}"
	region = "${var.region}"
}


resource "aws_instance" "consul" {
	instance_type = "m3.medium"
	private_ip = "10.0.100.7"
	subnet_id = "${aws_subnet.consul.id}"
	# iam_instance_profile = "consul"
	security_groups = ["${var.sg_ssh_base_id}", "${aws_security_group.consul_server.id}"]

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

	# wait until server is up
	provisioner "local-exec" {
		command = "sleep 30" #it takes a little while for the server to come up
	}

	# create tunnel on 12022 to chef 
	provisioner "local-exec" {
		command = "ssh -f -L 12022:${self.private_ip}:22 ec2-user@${var.jump_ip} -o StrictHostKeyChecking=no sleep 300 <&- >&- 2>&- &"
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
		source = "${path.module}/bootstrap-chef.sh"
		destination = "~/bootstrap-chef.sh"
    }

	provisioner "remote-exec" {
		inline = [
			"sudo mkdir -p /opt/bootstrap",
			"sudo mv -f ~/bootstrap-chef.sh /opt/bootstrap/",
			"sudo chmod 774 /opt/bootstrap/bootstrap-chef.sh", # make executable
			"sudo /opt/bootstrap/bootstrap-chef.sh"
		]
	}
}

