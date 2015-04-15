resource "aws_subnet" "consul" {
	vpc_id = "${var.vpc_id}"
	cidr_block = "10.0.100.0/24"
	availability_zone = "${var.zone_default}"
	tags {
		Name = "consul"
	}
}

resource "aws_subnet" "consul_alt" {
	vpc_id = "${var.vpc_id}"
	cidr_block = "10.0.101.0/24"
	availability_zone = "${var.zone_alt}"
	tags {
		Name = "consul-alt"
	}
}

