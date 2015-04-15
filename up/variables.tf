
############################
# REQUIRED
############################

variable "access_key" {}
variable "secret_key" {}
variable "aws_account_id" {}
variable "key_name" {}
variable "vpc_name" {}

############################
# Defaults
############################

variable "region" {
    default = "us-west-2"
}

variable "zone_default" {
	default = "us-west-2a"
}

variable "zone_alt" {
	default = "us-west-2b"
}

############################
# Lookup
############################

variable "amis" {
	default = {
		us-east-1 = "ami-aa7ab6c2" #ubuntu
		us-west-2 = "ami-f34032c3" #ubuntu
	}
}


