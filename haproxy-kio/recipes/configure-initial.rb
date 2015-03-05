#
# recipe::configure-initial
#
# meant to be run only on install

include_recipe 'runit'

config_file = "#{node['haproxy']['conf_dir']}/haproxy.cfg"

#blank config, only if none exists
template config_file do
  cookbook 'haproxy-kn'
  source 'haproxy.cfg.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'runit_service[haproxy]', :delayed
  not_if do
    File.exists?(config_file)
  end
end


