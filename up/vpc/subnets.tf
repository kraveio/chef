/*
	Strategy:
	0 - 9 Internet facing - DMZ, Proxy, NAT, Jump
	10 - 19 Adminstrative - OSSEC, AntiVirus, Monitoring
	20 - 29 API REST
	30 - 39 API Other
	40 - 49 Application Servers
	50 - 59 Caching - volatile

*/


## Front Facing ##

resource "aws_subnet" "nginx" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.3.0/24"
	availability_zone = "${var.zone_default}"
	tags {
		Name = "nginx"
	}
}

resource "aws_subnet" "nginx_alt" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.4.0/24"
	availability_zone = "${var.zone_alt}"
	tags {
		Name = "nginx-alt"
	}
}



## Persistent Storage ##

resource "aws_subnet" "consul" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.100.0/24"
	availability_zone = "${var.zone_default}"
	tags {
		Name = "consul"
	}
}

resource "aws_subnet" "consul_alt" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.101.0/24"
	availability_zone = "${var.zone_alt}"
	tags {
		Name = "consul-alt"
	}
}

