
resource "aws_security_group" "zookeeper_self" {
	vpc_id = "${aws_vpc.main.id}"
	name = "zookeeper_self"
	description = "Hack to work around circular reference limitation of Terraform"
}

resource "aws_security_group" "zookeeper" {
	vpc_id = "${aws_vpc.main.id}"
	name = "zookeeper"
	description = "Zookeeper"

	# client interface
	ingress {
		from_port = 2181
		to_port = 2181
		protocol = "tcp"
		cidr_blocks = ["${var.vpc_cidr_block}"] 
	}

	ingress {
		from_port = 2181
		to_port = 2181
		protocol = "tcp"
		cidr_blocks = ["${aws_security_group.zookeeper_self.id}"] 
	}

	ingress {
		from_port = 2888
		to_port = 2888
		protocol = "tcp"
		cidr_blocks = ["${aws_security_group.zookeeper_self.id}"] 
	}

	ingress {
		from_port = 3888
		to_port = 3888
		protocol = "tcp"
		cidr_blocks = ["$aws_security_group.zookeeper_self.id}"] 
	}

}
