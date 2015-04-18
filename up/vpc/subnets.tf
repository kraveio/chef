/*
	Strategy:
	- even numbers primary zone, odd numbers alt zone
	- low numbers tend to call 'back' to higher numbers

	** DMZ - Public IP **
	00 - 03 DMZ (HAProxy, NAT, JUMP)

	** Internet facing Generic - Private IP **
	04 - 09 Nginx, SMTP, Notification

	** API, Application, Processing **
	10 - 19 Specialized - Queue, WebSockets, Realtime, Presence
	20 - 39 API - REST 
	40 - 59 Processing
	
	** 60 Short Term / Volatile Storage **
	60 - 69 Caching  - Redis(fall through), Raik (tmp)

	** Medium Term Storage **
	70 - 79 Medium - Kafka(medium), GoPED (medium) 

	** Administrative **
	80 - 89 TBD
	90 - 99 Config (Consul, Zookeeper), Sec(OSSEC, AntiVirus), Monitoring, Logging, Elastic Search for logs, Logstash

	** Long Term Storage **
	100 - 199 - perm data store - Kafka(Perm), GoPED (Perm), Redis (Perm), Elastic Search 
	200 - 249 - canonical data store - Couchbase, SQL, Hadoop, DW, GraphDB
*/


## Front Facing ##

resource "aws_subnet" "nginx" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.4.0/24"
	availability_zone = "${var.zone_default}"
	tags {
		Name = "nginx"
	}
}

resource "aws_subnet" "nginx_alt" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.5.0/24"
	availability_zone = "${var.zone_alt}"
	tags {
		Name = "nginx-alt"
	}
}

## Api ##

resource "aws_subnet" "api" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.20.0/24"
	availability_zone = "${var.zone_default}"
	tags {
		Name = "api"
	}
}

resource "aws_subnet" "api_alt" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.21.0/24"
	availability_zone = "${var.zone_alt}"
	tags {
		Name = "api-alt"
	}
}

## Processing ##

resource "aws_subnet" "img" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.40.0/24"
	availability_zone = "${var.zone_default}"
	tags {
		Name = "img"
	}
}

resource "aws_subnet" "img_alt" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.41.0/24"
	availability_zone = "${var.zone_alt}"
	tags {
		Name = "img-alt"
	}
}

## Volatile ##

resource "aws_subnet" "redis_cache" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.60.0/24"
	availability_zone = "${var.zone_default}"
	tags {
		Name = "redis-cache"
	}
}

resource "aws_subnet" "cache_alt" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.61.0/24"
	availability_zone = "${var.zone_alt}"
	tags {
		Name = "redis-cache-alt"
	}
}

## Persistent Storage ##

resource "aws_subnet" "log" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.90.0/24"
	availability_zone = "${var.zone_default}"
	tags {
		Name = "log"
	}
}

resource "aws_subnet" "log_alt" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.91.0/24"
	availability_zone = "${var.zone_alt}"
	tags {
		Name = "log-alt"
	}
}

resource "aws_subnet" "metric" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.92.0/24"
	availability_zone = "${var.zone_default}"
	tags {
		Name = "metric"
	}
}

resource "aws_subnet" "metric_alt" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.93.0/24"
	availability_zone = "${var.zone_alt}"
	tags {
		Name = "metric-alt"
	}
}

resource "aws_subnet" "deploy" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.94.0/24"
	availability_zone = "${var.zone_default}"
	tags {
		Name = "deploy"
	}
}

resource "aws_subnet" "deploy_alt" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.95.0/24"
	availability_zone = "${var.zone_alt}"
	tags {
		Name = "deploy-alt"
	}
}

resource "aws_subnet" "sec" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.96.0/24"
	availability_zone = "${var.zone_default}"
	tags {
		Name = "sec"
	}
}

resource "aws_subnet" "sec_alt" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.97.0/24"
	availability_zone = "${var.zone_alt}"
	tags {
		Name = "sec-alt"
	}
}

resource "aws_subnet" "server_state" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.98.0/24"
	availability_zone = "${var.zone_default}"
	tags {
		Name = "server-state"
	}
}

resource "aws_subnet" "server_state_alt" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.99.0/24"
	availability_zone = "${var.zone_alt}"
	tags {
		Name = "server-state-alt"
	}
}

## Long Term Storage - Perm ##

resource "aws_subnet" "kafka_db" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.102.0/24"
	availability_zone = "${var.zone_default}"
	tags {
		Name = "kafka_db"
	}
}

resource "aws_subnet" "kafka_db_alt" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.103.0/24"
	availability_zone = "${var.zone_alt}"
	tags {
		Name = "kafka_db-alt"
	}
}

resource "aws_subnet" "redis_db" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.110.0/24"
	availability_zone = "${var.zone_default}"
	tags {
		Name = "redis_db"
	}
}

resource "aws_subnet" "redis_db_alt" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.111.0/24"
	availability_zone = "${var.zone_alt}"
	tags {
		Name = "redis_db-alt"
	}
}

## Long Term Storage - Canonical ##

resource "aws_subnet" "couchbase" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.200.0/24"
	availability_zone = "${var.zone_default}"
	tags {
		Name = "couchbase"
	}
}

resource "aws_subnet" "couchbase_alt" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.201.0/24"
	availability_zone = "${var.zone_alt}"
	tags {
		Name = "couchbase-alt"
	}
}

