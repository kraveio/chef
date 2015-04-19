resource "aws_security_group" "redis_client" {
	vpc_id = "${aws_vpc.main.id}"
	name = "redis-client"
	description = "Redis Client - Marker Group"
}

resource "aws_security_group" "redis_server" {
	vpc_id = "${aws_vpc.main.id}"
	name = "redis-server"
	description = "Redis Server"

	# couchbase plugin
	ingress {
		from_port = 6379
		to_port = 6379
		protocol = "tcp"
		security_groups = ["${aws_security_group.redis_client.id}"]
	}
}

