
provider "aws" {
	access_key = "${var.access_key}"
	secret_key = "${var.secret_key}"
	region = "${var.region}"
}

resource "aws_vpc" "main" {
	cidr_block = "10.0.0.0/16"
	enable_dns_support = true

	tags {
		Name = "${var.vpc_name}"
	}
}

resource "aws_internet_gateway" "main" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "gw"
    }
}

##########################
# NATmain routing table NAT
##########################

resource "aws_route_table" "nat" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }

    tags {
        Name = "nat"
    }
}

resource "aws_main_route_table_association" "main" {
    vpc_id = "${aws_vpc.main.id}"
    route_table_id = "${aws_route_table.nat.id}"
}

############################
# DMZ routing
############################

resource "aws_route_table" "dmz" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main.id}"
    }

    tags {
        Name = "dmz"
    }
}

# set the DMZ subnet to be connect to the internet
resource "aws_route_table_association" "dmz" {
    subnet_id = "${aws_subnet.dmz.id}"
    route_table_id = "${aws_route_table.dmz.id}"
}

# set the DMZ-alt subnet to be connect to the internet
resource "aws_route_table_association" "dmz_alt" {
    subnet_id = "${aws_subnet.dmz_alt.id}"
    route_table_id = "${aws_route_table.dmz.id}"
}

############################
# NAT Instance
############################

resource "aws_instance" "nat" {
	instance_type = "m1.small"
	private_ip = "10.0.0.250"
	source_dest_check = false				#important for nat
	subnet_id = "${aws_subnet.dmz.id}"
	security_groups = ["${aws_security_group.nat.id}"]
	ami = "${lookup(var.nat_amis, var.region)}"
	availability_zone = "${var.zone_default}"
	key_name = "${var.key_name}"
	root_block_device {
#		volume_size = ""
		delete_on_termination = true
	}
	tags {
		Name = "nat"
	}
	provisioner "remote-exec" {
		inline = [
			"sudo yum update -y"
		]
		connection {
			user = "ec2-user"
			agent = true
		}
	}

}
