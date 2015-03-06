#
# recipe::dependency
#

layer_name = node[:consul_kio][:layers][:consul]
node.normal['consul']['servers'] = node[:stack][layer_name][:ips]


