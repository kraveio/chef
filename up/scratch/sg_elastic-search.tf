resource "aws_security_group" "elasticsearch_data_self" {
	vpc_id = "${aws_vpc.main.id}"
	name = "elasticsearch-data-self"
	description = "Hack to work around circular reference limitation of Terraform"
}

resource "aws_security_group" "elasticsearch_data" {
	vpc_id = "${aws_vpc.main.id}"
	name = "elasticsearch-data"
	description = "Elastic Search Data"
}

resource "aws_security_group" "elasticsearch_transport" {
	vpc_id = "${aws_vpc.main.id}"
	name = "elasticsearch_transport"
	description = "All types of ES Nodes communicate on the transport port"

	ingress {
		from_port = 9300
		to_port = 9300
		protocol = "tcp"
		security_groups = ["${aws_security_group.elasticsearch_master.id}"]
	}

	ingress {
		from_port = 9300
		to_port = 9300
		protocol = "tcp"
		security_groups = ["${aws_security_group.elasticsearch_data.id}"]
	}

	ingress {
		from_port = 9300
		to_port = 9300
		protocol = "tcp"
		security_groups = ["${aws_security_group.elasticsearch_http.id}"]
	}
}

resource "aws_security_group" "elasticsearch_http" {
	vpc_id = "${aws_vpc.main.id}"
	name = "elasticsearch-http"
	description = "Elastic Search Rest Interface"

	# query - REST api
	ingress {
		from_port = 9200
		to_port = 9200
		protocol = "tcp"
		cidr_blocks = ["${var.vpc_cidr_block}"] 
	}
}

# resource "aws_security_group" "elasticsearch_couchbase" {
#	vpc_id = "${aws_vpc.main.id}"
#	name = "elasticsearch-http"
#	description = "Elastic Search Rest Interface"
#
#	# couchbase plugin
#	ingress {
#		from_port = 9091
#		to_port = 9091
#		protocol = "tcp"
#		cidr_blocks = ["${var.vpc_cidr_block}"] 
#	}
#}


# all communication between nodes is done using the transport module TCP(9300) (with the exception 
# of the multicast protocol UDP(54328)
# Each value is either in the form of host:port, or in the form of host[port1-port2].

resource "aws_security_group" "elasticsearch_master" {
	vpc_id = "${aws_vpc.main.id}"
	name = "elasticsearch-master"
	description = "Elastic Search Master Node"
}


resource "aws_security_group" "elasticsearch_dev" {
	vpc_id = "${aws_vpc.main.id}"
	name = "elasticsearch-multicast"
	description = "Zen multicast discovery for dev "
	
	# http://www.elastic.co/guide/en/elasticsearch/guide/current/_important_configuration_changes.html
	# In production, it is recommended to use unicast (tcp) instead of multicast (udp).
	# This works by providing Elasticsearch a list of nodes that it should try to contact.
	# Once the node contacts a member of the unicast list, it will receive a full cluster 
	# state that lists all nodes in the cluster. It will then proceed to contact the master and join.
	# discovery.zen.ping.multicast.enabled: false 
	# discovery.zen.ping.unicast.hosts: ["host1", "host2:port"]

	# The unicast discovery allows for discovery when multicast is not enabled.
	# It basically requires a list of hosts to use that will act as gossip routers.
	# It provides the following settings with the discovery.zen.ping.unicast prefix:

	# The zen discovery is the built in discovery module for elasticsearch 
#	ingress {
#		from_port = 54328
#		to_port = 54328
#		protocol = "ucp"
#		security_groups = ["${aws_security_group.elasticsearch_master_self.id}"]
#	}
}

