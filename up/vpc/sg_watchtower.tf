resource "aws_security_group" "watchtower" {
	vpc_id = "${aws_vpc.main.id}"
	name = "watchtower"
	description = "Access to all servers - Marker Group"
}

