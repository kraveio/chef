resource "aws_security_group" "logstash_forwarder" {
	vpc_id = "${aws_vpc.main.id}"
	name = "logstash-client"
	description = "Logstash Forarder Client - Marker Group"
}

resource "aws_security_group" "logstash" {
	vpc_id = "${aws_vpc.main.id}"
	name = "logstash"
	description = "Logstash Receivers"

	ingress {
		from_port = 12345
		to_port = 12345
		protocol = "tcp"
		security_groups = ["{aws_security_group.linux_base.id}"]
	}
}

