
variable "access_key" {}
variable "secret_key" {}

variable "region" {
    default = "us-west-2"
}

variable "zone_default" {
	default = "us-west-2a"
}

variable "zone_alt" {
	default = "us-west-2b"
}

variable "key_name" {
	default = "Master2014"
}

variable "aws_key_path" {
	default = "/Users/wise/.ssh/taku/ThumbnailMaster2014.pem"
}


variable "amis" {
	default = {
		us-east-1 = "ami-aa7ab6c2" #ubuntu
		us-west-2 = "ami-f34032c3" #ubuntu
	}
}

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

###################
#  VPC
################### 

variable "vpc_name" { }
variable "aws_account_id" { }

# todo - figure out how to do array variable for jump security group ips

# arn:aws:service:region:account:resource
# arn:aws:iam::123456789012:instance-profile/Webserver
