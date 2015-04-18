resource "aws_security_group" "ossec_client" {
	vpc_id = "${aws_vpc.main.id}"
	name = "ossec-client"
	description = "OSSEC Client - Marker Group"
}

resource "aws_security_group" "ossec" {
	vpc_id = "${aws_vpc.main.id}"
	name = "ossec"
	description = "OSSEC Receivers"

	ingress {
		from_port = 1514
		to_port = 1514
		protocol = "ucp"
		security_groups = ["{aws_security_group.ossec_client.id}"]
	}
}

