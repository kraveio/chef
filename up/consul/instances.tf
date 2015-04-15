provider "aws" {
	access_key = "${var.access_key}"
	secret_key = "${var.secret_key}"
	region = "${var.region}"
}

variable "consul_server_ips" {
  default = {
    "0" = "10.0.100.7"
    "1" = "10.0.100.8"
    "2" = "10.0.100.9"
  }
}

resource "aws_instance" "consul" {
	instance_type = "m3.medium"
	private_ip = "${lookup(var.consul_server_ips, count.index)}"
	subnet_id = "${aws_subnet.consul.id}"
	security_groups = ["${var.sg_ssh_base_id}", "${aws_security_group.consul_server.id}"]

	# iam_instance_profile = "consul"

	ami = "${var.ami}"
	availability_zone = "${var.zone_default}"
	key_name = "${var.key_name}"
	source_dest_check = true

	##TODO: Need more storage

	root_block_device {
		delete_on_termination = "${var.is_prod}"
	}

	tags {
		Name = "consul-0${count.index+1}"
	}

	# wait until server is up
	provisioner "local-exec" {
		command = "sleep ${var.sleep_seconds}" #it takes a little while for the server to come up
	}

	# create tunnel on 12022 to chef 
	provisioner "local-exec" {
		command = "ssh -f -L 12022:${self.private_ip}:22 ec2-user@${var.jump_ip} -o StrictHostKeyChecking=no sleep ${var.ssh_wait_seconds} <&- >&- 2>&- &"
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

