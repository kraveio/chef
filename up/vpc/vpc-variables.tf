

############################
# REQUIRED
############################

variable "access_key" {}
variable "secret_key" {}
variable "aws_account_id" {}
variable "key_name" {}
variable "vpc_name" {}

variable "region" {}
variable "zone_default" {}
variable "zone_alt" {}
variable "chef_ami" {}


# to be put onto the jump server
# not clear if we can find a better approach
variable "aws_key_path" {}

############################
# DEFAULTS
############################

variable "vpc_cidr_block" {
	default = "10.0.0.0/16"
}

variable "sleep_seconds" {
	default = "45"
}

variable "ssh_wait_seconds" {
	default = "260"
}

variable "jump_access_cidr" {
	default = "0.0.0.0/0" # use + to delimit more
}

############################
# LOOKUP
############################

variable "nat_amis" {
	default = {
		us-west-2 = "ami-49691279"
	}
}

variable "jump_amis" {
	default = {
		us-west-2 = "ami-d13845e1"
	}
}


############################
# OUTPUT
############################

output "vpc_id" {
    value = "${aws_vpc.main.id}"
}

output "sg_ssh_base_id" {
    value = "${aws_security_group.ssh_base.id}"
}

output "jump_ip" {
	value = "${aws_instance.jump.public_ip}"
}

