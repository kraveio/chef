#
# attributes::default.rb
#

default['consul']['version']        = '0.4.1'
default['consul']['install_method'] = 'binary'

default['consul']['install_dir']    = '/usr/local/bin'
default['consul']['config_dir'] = '/etc/consul.d'
default['consul']['data_dir'] = '/var/lib/consul'

default['consul']['init_style'] = 'runit'
default['consul']['service_user'] = 'consul'
default['consul']['service_group'] = 'consul'

default['consul']['ports'] = {
  'dns'      => 8600,
  'http'     => 8500,
  'https'    => -1,
  'rpc'      => 8400,
  'serf_lan' => 8301,
  'serf_wan' => 8302,
  "server"   => 8300,
}

# Gossip encryption
default['consul']['encrypt_enabled'] = false
default['consul']['encrypt'] = nil

# mode 
default['consul']['service_mode'] = 'cluster' #client, server, cluster

# TODO: expect 3 servers
default['consul']['bootstrap_expect'] = 1
default['consul']['servers'] = [] #set in recipe::dependencies

