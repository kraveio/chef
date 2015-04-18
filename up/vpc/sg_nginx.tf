
resource "aws_security_group" "nginx" {
	vpc_id = "${aws_vpc.main.id}"
	name = "nginx"
	description = "Nginx"

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		security_groups = ["{aws_security_group.public-lb.id}"]
	}

	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		security_groups = ["{aws_security_group.public-lb.id}"]
	}
}

