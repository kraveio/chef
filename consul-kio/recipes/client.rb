#
# recipe::client.rb
#

node.default['consul']['service_mode'] = 'client'

include_recipe 'consul-kio::dependencies'
include_recipe 'consul::install_binary'

