#
# recipe::server.rb
#

node.default['consul']['service_mode'] = 'cluster'
node.default['consul']['serve_ui'] = true

include_recipe 'consul-kio::dependencies'
include_recipe 'consul::install_binary'
include_recipe 'consul::ui'
