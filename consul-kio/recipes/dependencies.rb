#
# recipe::dependency
#

include_recipe 'aws-util::opsworks_hosts'

layer_name = node[:consul_kio][:layers][:consul]
node.normal['consul']['servers'] = node[:stack][layer_name][:ips]


