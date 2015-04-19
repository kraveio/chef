
resource "aws_security_group" "kafka_client" {
	vpc_id = "${aws_vpc.main.id}"
	name = "kafka_client"
	description = "Kafka Client - Marker Group"
}

resource "aws_security_group" "kafka_server" {
	vpc_id = "${aws_vpc.main.id}"
	name = "kafka_server"
	description = "Kafka Server"

	# client interface
	ingress {
		from_port = 9092
		to_port = 9092
		protocol = "tcp"
		security_groups = ["${aws_security_group.kafka_client.id}"] 
	}
}


