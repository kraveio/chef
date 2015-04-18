
resource "aws_security_group" "zookeeper_client" {
	vpc_id = "${aws_vpc.main.id}"
	name = "zookeeper_client"
	description = "Zookeeper Client - Marker Group"
}

resource "aws_security_group" "zookeeper_server" {
	vpc_id = "${aws_vpc.main.id}"
	name = "zookeeper_server"
	description = "Zookeeper Server"

	# client interface
	ingress {
		from_port = 2181
		to_port = 2181
		protocol = "tcp"
		cidr_blocks = ["${aws_security_group.zookeeper_client.id}"] 
	}
}

resource "aws_security_group" "zookeeper_internal" {
	vpc_id = "${aws_vpc.main.id}"
	name = "zookeeper_internal"
	description = "Zookeeper intra-node communication"

	ingress {
		from_port = 2181
		to_port = 2181
		protocol = "tcp"
		cidr_blocks = ["${aws_security_group.zookeeper_server.id}"] 
	}

	ingress {
		from_port = 2888
		to_port = 2888
		protocol = "tcp"
		cidr_blocks = ["${aws_security_group.zookeeper_server.id}"] 
	}

	ingress {
		from_port = 3888
		to_port = 3888
		protocol = "tcp"
		cidr_blocks = ["$aws_security_group.zookeeper_server.id}"] 
	}
}
