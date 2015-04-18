resource "aws_security_group" "couchbase_admin_client" {
	vpc_id = "${aws_vpc.main.id}"
	name = "couchbase-admin-client"
	description = "Market group indicating its holder is an admin client of a couchbase server cluster"
}

resource "aws_security_group" "couchbase_internode_client" {
	vpc_id = "${aws_vpc.main.id}"
	name = "couchbase-internode-client"
	description = "marker group allows connections to the internode ports"
}

resource "aws_security_group" "couchbase_client" {
	vpc_id = "${aws_vpc.main.id}"
	name = "couchbase_client"
	description = "Marker group that when used allows connection to Couchbase as a Client"
}

resource "aws_security_group" "couchbase_server" {
	vpc_id = "${aws_vpc.main.id}"
	name = "elasticsearch-server"
	description = "Clients will connect on these ports"

	# REST Interface
	ingress {
		from_port = 8091
		to_port = 8091
		protocol = "tcp"
		security_groups = ["${aws_security_group.couchbase_client.id}",
						"${aws_security_group.couchbase_admin_client.id}",
						"${aws_security_group.couchbase_internode_client.id}"]
	}

	# Couchbase API Port ** main client port **
	# Used to access views, run queries, and update design documents.
	ingress {
		from_port = 8092
		to_port = 8092
		protocol = "tcp"
		security_groups = ["${aws_security_group.couchbase_client.id}", 
						"${aws_security_group.couchbase_internode_client.id}" ]
	}

	# Internal Bucket Port
	ingress {
		from_port = 11209
		to_port = 11209
		protocol = "tcp"
		security_groups = ["${aws_security_group.couchbase_internode_client.id}"]
	}

	# Internal/External Bucket Port
	ingress {
		from_port = 11210
		to_port = 11210
		protocol = "tcp"
		security_groups = ["${aws_security_group.couchbase_client.id}",
				"${aws_security_group.couchbase_internode_client.id}"]
	}
	
	# Port 11213 is an internal ports used on the local host for memcached and compaction. 
	ingress {
		from_port = 11213
		to_port = 11213
		protocol = "tcp"
		cidr_blocks= ["127.0.0.1/32"]
	}

	## SSL Versions of the ports above

	# Internal/External Bucket Port for SSL
	# Used by smart client libraries to access data nodes using SSL.
	ingress {
		from_port = 11207
		to_port = 11207
		protocol = "tcp"
		security_groups = ["${aws_security_group.couchbase_client.id}"]
	}

	# Internal REST HTTPS for SSL
	# Used by the Couchbase Web Console for REST/HTTP traffic with SSL.
	ingress {
		from_port = 18091
		to_port = 18091
		protocol = "tcp"
		security_groups = ["${aws_security_group.couchbase_client.id}",
						   "${aws_security_group.couchbase_admin_client.id}"]
	}

	# Internal CAPI HTTPS for SSL	
	# Used to access views, run queries, and update design documents with SSL.
	ingress {
		from_port = 18092
		to_port = 18092
		protocol = "tcp"
		security_groups = ["${aws_security_group.couchbase_client.id}"]
	}

	## Erlang and Node Data ##

	# Erlang Port Mapper ( epmd )
	ingress {
		from_port = 4369
		to_port = 4369
		protocol = "tcp"
		security_groups = ["${aws_security_group.couchbase_internode_client.id}"]
	}

	# Node data exchange
	ingress {
		from_port = 21100
		to_port = 21299
		protocol = "tcp"
		security_groups = ["${aws_security_group.couchbase_internode_client.id}"]
	}
}

