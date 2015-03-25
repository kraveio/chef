resource "aws_security_group" "jump" {
	vpc_id = "${aws_vpc.main.id}"
	name = "jump"
	description = "A jump server"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		# todo - figure out how to use array variable here
		cidr_blocks = ["0.0.0.0/0"]
	}

}

resource "aws_security_group" "ssh_internal" {
	vpc_id = "${aws_vpc.main.id}"
	name = "ssh-jump"
	description = "Allow SSH access from the jump server"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		security_groups = ["${aws_security_group.jump.id}"]
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
		security_groups = ["${aws_security_group.jump.id}"]
	}

}

resource "aws_security_group" "nat" {
	vpc_id = "${aws_vpc.main.id}"
	name = "jump"
	description = "A jump nat server"

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



