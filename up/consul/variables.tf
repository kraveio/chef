
############################
# COMMON
############################

variable "access_key" {}
variable "secret_key" {}
variable "aws_account_id" {}
variable "key_name" {}
variable "vpc_id" {}

variable "region" {}
variable "zone_default" {}
variable "zone_alt" {}
variable "ami" {}

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

variable "is_prod" {
	default = "false"
}

############################
# MODULE
############################

variable "sg_ssh_base_id" {
	value = "tests"
}
variable "jump_ip" {
	value = "test"
}

