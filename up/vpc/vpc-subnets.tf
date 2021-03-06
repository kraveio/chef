
resource "aws_subnet" "dmz" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.0.0/24"
	availability_zone = "${var.zone_default}"
	map_public_ip_on_launch = true
	tags {
		Name = "DMZ"
	}
}

resource "aws_subnet" "dmz_alt" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.1.0/24"
	availability_zone = "${var.zone_alt}"
	map_public_ip_on_launch = true
	tags {
		Name = "DMZ-alt"
	}
}


