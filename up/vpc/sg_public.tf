
resource "aws_security_group" "public-web" {
	vpc_id = "${aws_vpc.main.id}"
	name = "public-web"
	description = "Public Facing www ports"

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "public-ping" {
	vpc_id = "${aws_vpc.main.id}"
	name = "public-ping"
	description = "Allow Ping from the Internet"

	ingress {
		from_port = -1
		to_port = -1
		protocol = "icmp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "public-incapsula" {
	vpc_id = "${aws_vpc.main.id}"
	name = "public-incapsula"
	description = "Allow Incapsula traffic on www ports"

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = [
			"45.64.64.0/22", 
			"103.28.248.0/22",
			"149.126.72.0/21",
			"185.11.124.0/22",
			"192.230.64.0/18",
			"198.143.32.0/19",
			"199.83.128.0/21"
		]
	}

	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = [
			"45.64.64.0/22",
			"103.28.248.0/22",
			"149.126.72.0/21",
			"185.11.124.0/22",
			"192.230.64.0/18",
			"198.143.32.0/19",
			"199.83.128.0/21"
		]
	}
}







