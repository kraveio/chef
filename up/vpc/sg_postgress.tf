
resource "aws_security_group" "postgres_client" {
	vpc_id = "${aws_vpc.main.id}"
	name = "postgres_client"
	description = "Postgres Client - Marker Group"
}

resource "aws_security_group" "postgres_server" {
	vpc_id = "${aws_vpc.main.id}"
	name = "postgres_server"
	description = "Postgres Server"

	# client interface
	ingress {
		from_port = 5432
		to_port = 5432
		protocol = "tcp"
		security_groups = ["${aws_security_group.postgres_client.id}"] 
	}
}


