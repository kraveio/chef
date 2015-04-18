
resource "aws_security_group" "prometheus_client" {
	vpc_id = "${aws_vpc.main.id}"
	name = "prometheus_client"
	description = "Prometheus Client"
}

resource "aws_security_group" "prometheus_server" {
	vpc_id = "${aws_vpc.main.id}"
	name = "prometheus_server"
	description = "Prometheus Server"

	ingress {
		from_port = 9090
		to_port = 9090
		protocol = "tcp"
		security_groups = ["${aws_security_group.prometheus_client.id}"]
	}
}
