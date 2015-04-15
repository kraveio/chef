

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
variable "aws_key_path" { }

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


