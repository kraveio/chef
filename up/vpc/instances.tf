resource "aws_instance" "consul" {
	depends_on = ["aws_instance.nat", "aws_instance.jump", "aws_route_table.nat"]
	instance_type = "m3.medium"
	private_ip = "10.0.10.7"
	subnet_id = "${aws_subnet.admin.id}"
	#iam_instance_profile = "chef"
	security_groups = ["${aws_security_group.ssh_base.id}", "${aws_security_group.consul_server.id}"]
	ami = "${lookup(var.chef_amis, var.region)}"
	availability_zone = "${var.zone_default}"
	key_name = "${var.key_name}"
	source_dest_check = true

	root_block_device {
		delete_on_termination = true
	}

	tags {
		Name = "${format("consul-%02d", count.index+1)}"
	}

	# wait until server is up
	provisioner "local-exec" {
		command = "sleep ${var.sleep_seconds}" #it takes a little while for the server to come up
	}

	# create tunnel on 12022 to server
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
			"mkdir -p ~/bootstrap",
			"sudo mkdir -p /opt"
		]
	}

	provisioner "file" {
		source = "${path.module}/bootstrap/"
		destination = "~/bootstrap"
    }

	# curl http://169.254.169.254/latest/meta-data/hostname
	provisioner "remote-exec" {
		# this way, if needed we can see what script was used to bootstrap the box
		inline = [
			"echo '{\"set_fqdn\":\"${format("consul-%02d", count.index+1)}\"}' >> ~/bootstrap/hostname.json",
			"sudo mv -f ~/bootstrap /opt/",
			"sudo bash /opt/bootstrap/bootstrap-chef-sdk.sh"
		]
	}
}

