
# CHEF
# m3.large (2cpu, 7.5gb) is probably the ideal size or c3.xlarge (4cpu, 7.5gb)
#
resource "aws_instance" "chef" {
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
# TODO: enable connect with SSH KEY
#	provisioner "remote-exec" {
#		script = "./bootstrap-chef.sh"
#	}
}

resource "aws_instance" "jump_server" {
	instance_type = "t2.micro"
	private_ip = "10.0.0.7"
	subnet_id = "${aws_subnet.dmz.id}"
	security_groups = ["${aws_security_group.nat.id}"]
	ami = "${lookup(var.jump_amis, var.region)}"
	availability_zone = "${var.zone_default}"
	key_name = "${var.key_name}"
	root_block_device {
#		volume_size = ""
		delete_on_termination = true
	}
	tags {
		Name = "jump"
	}
}


