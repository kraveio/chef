resource "aws_security_group" "elasticsearch_data" {
	vpc_id = "${aws_vpc.main.id}"
	name = "elasticsearch-data"
	description = "Elastic Search Data"

	ingress {
		from_port = 9091
		to_port = 9091
		protocol = "tcp"
		cidr_blocks = ["${var.vpc_cidr_block}"] 
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
		security_groups = ["${aws_security_group.elasticsearch_master.id}"]
	}


	ingress {
		from_port = 54328
		to_port = 54328
		protocol = "tcp"
		security_groups = ["${aws_security_group.elasticsearch_data.id}"]
	}

	ingress {
		from_port = 54328
		to_port = 54328
		protocol = "tcp"
		security_groups = ["${aws_security_group.elasticsearch_master.id}"]
	}

}

resource "aws_security_group" "elasticsearch_master" {
	vpc_id = "${aws_vpc.main.id}"
	name = "elasticsearch-master"
	description = "Elastic Search Search"

	# sync
	ingress {
		from_port = 9091
		to_port = 9091
		protocol = "tcp"
		cidr_blocks = ["${var.vpc_cidr_block}"] 
	}
	
	# query
	ingress {
		from_port = 9200
		to_port = 9200
		protocol = "tcp"
		cidr_blocks = ["${var.vpc_cidr_block}"] 
	}

	ingress {
		from_port = 9300
		to_port = 9300
		protocol = "tcp"
		security_groups = ["${aws_security_group.elasticsearch_master.id}"]
	}

	ingress {
		from_port = 54328
		to_port = 54328
		protocol = "tcp"
		security_groups = ["${aws_security_group.elasticsearch_master.id}"]
	}
}
