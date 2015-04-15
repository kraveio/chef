module "bootstrap" {
    source = "./bootstrap"

	access_key = "${var.access_key}"
	secret_key = "${var.secret_key}"
	region = "${var.region}"
	aws_account_id = "${var.aws_account_id}"
	vpc_name = "${var.vpc_name}"
	key_name = "${var.key_name}"
	aws_key_path = "${var.aws_key_path}"

	region = "${var.region}"
	zone_default = "${var.zone_default}"
	zone_alt = "${var.zone_alt}"
	chef_ami =  "${lookup(var.amis, var.region)}"
}

#output "child_memory" {
#    value = "${module.child.received}"
#}
