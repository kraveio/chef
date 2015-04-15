module "bootstrap" {
    source = "./bootstrap"

	## Common ##

	access_key = "${var.access_key}"
	secret_key = "${var.secret_key}"
	aws_account_id = "${var.aws_account_id}"
	key_name = "${var.key_name}"

	## Region ##

	region = "${var.region}"
	zone_default = "${var.zone_default}"
	zone_alt = "${var.zone_alt}"

	## Specific ##

	aws_key_path = "${var.aws_key_path}"
	chef_ami =  "${lookup(var.amis, var.region)}"
	vpc_name = "${var.vpc_name}"
}

output "vpc_id" {
    value = "${module.bootstrap.vpc_id}"
}

output "jump_ip" {
	value = "${module.bootstrap.jump_ip}"
}

module "consul" {
    source = "./consul"

	## Common ##

	access_key = "${var.access_key}"
	secret_key = "${var.secret_key}"
	aws_account_id = "${var.aws_account_id}"
	key_name = "${var.key_name}"

	## Region ##

	region = "${var.region}"
	zone_default = "${var.zone_default}"
	zone_alt = "${var.zone_alt}"

	## Specific ##

	ami =  "${lookup(var.amis, var.region)}"
	vpc_id = "${module.bootstrap.vpc_id}"
	sg_ssh_base_id = "${module.bootstrap.sg_ssh_base_id}"
	jump_ip = "${module.bootstrap.jump_ip}"
}

