#
# recipe::configure
#

include_recipe 'runit'
include_recipe 'consul-template::install_binary'

runit_service 'haproxy' do
  action :nothing 
end

config_dir = node['haproxy']['conf_dir']
config_file = "#{config_dir}/haproxy.cfg"
config_template = "#{config_dir}/haproxy.cfg.tmpl"

# blank config, only if none exists
template config_file do
  cookbook	'haproxy-kio'
  source	'haproxy.cfg.erb'
  owner		'root'
  group		'root'
  mode		0644
  notifies :restart, 'runit_service[haproxy]', :delayed
  not_if do
    File.exists?(config_file)
  end
end

#consul template
template config_template do
  cookbook	'haproxy-kio'
  source	'haproxy.cfg.ctmpl.erb'
  owner		'root'
  group		'root'
  mode		0644
  notifies :restart, 'runit_service[haproxy]', :delayed
end

#consul template setup
consul_template_config 'haproxy' do
  templates [{
    source:		config_template,
    destination:config_file,
    command:	'service haproxy restart'
  }]
  notifies :reload, 'runit_service[consul-template]', :delayed
end

include_recipe 'consul-template::service'
