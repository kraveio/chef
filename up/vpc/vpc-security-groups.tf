resource "aws_security_group" "jump" {
	vpc_id = "${aws_vpc.main.id}"
	name = "jump"
	description = "A jump server"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["${split("+",var.jump_access_cidr)}"]
	}
}

resource "aws_security_group" "ssh_base" {
	vpc_id = "${aws_vpc.main.id}"
	name = "ssh-base"
	description = "Allow SSH access from the jump server"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		security_groups = ["${aws_security_group.jump.id}",
						"${aws_security_group.watchtower.id}"]
	}

	ingress {
		from_port = -1
		to_port = -1
		protocol = "icmp"
		cidr_blocks = ["${var.vpc_cidr_block}"]
	}
}

resource "aws_security_group" "nat" {
	vpc_id = "${aws_vpc.main.id}"
	name = "nat"
	description = "For nat servers out"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		security_groups = ["${aws_security_group.jump.id}"]
	}

	ingress {
		from_port = -1
		to_port = -1
		protocol = "-1"
		security_groups = ["${aws_security_group.ssh_base.id}"]
	}
}

resource "aws_security_group" "chef" {
	vpc_id = "${aws_vpc.main.id}"
	name = "chef"
	description = "Chef Servers"
}



