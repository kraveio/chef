
resource "aws_security_group" "consul_client" {
	vpc_id = "${var.vpc_id}"
	name = "consul_client"
	description = "Consul Clients"

	ingress {
		from_port = 8301
		to_port = 8301
		protocol = "tcp"
		cidr_blocks = ["${var.vpc_cidr_block}"] 
	}

	ingress {
		from_port = 8400
		to_port = 8400
		protocol = "tcp"
		cidr_blocks = ["127.0.0.1/32"]
	}

	ingress {
		from_port = 8500
		to_port = 8500
		protocol = "tcp"
		cidr_blocks = ["127.0.0.1/32"]
	}

	ingress {
		from_port = 8600
		to_port = 8600
		protocol = "tcp"
		cidr_blocks = ["127.0.0.1/32"]
	}
}

resource "aws_security_group" "consul_server" {
	vpc_id = "${var.vpc_id}"
	name = "consul_server"
	description = "Consul Server"

	ingress {
		from_port = 8300
		to_port = 8300
		protocol = "tcp"
		cidr_blocks = ["${var.vpc_cidr_block}"] 
	}

	ingress {
		from_port = 8301
		to_port = 8301
		protocol = "tcp"
		cidr_blocks = ["${var.vpc_cidr_block}"] 
	}

	ingress {
		from_port = 8302
		to_port = 8302
		protocol = "tcp"
		cidr_blocks = ["${var.vpc_cidr_block}"] 
	}

}

