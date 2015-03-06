#
# attributes::default
#

name = 'haproxy'

default[:haproxy][:service][:name] = name
default[:haproxy][:service][:user] = 'root'
default[:haproxy][:service][:group] = 'root'
default[:haproxy][:service][:conf_dir] = '/etc/haproxy'

default[:haproxy][:package][:version] = nil
default[:haproxy][:config][:template_cookbook] = 'haproxy'
