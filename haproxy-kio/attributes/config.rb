#
# attributes::config
#


default[:haproxy][:enable_stats] = true
default[:haproxy][:stats_password] = 'changeMe'
default[:haproxy][:stats_url] = '/haproxy?stats'
default[:haproxy][:stats_user] = 'admin'
default[:haproxy][:check_interval] = '10s'

default[:haproxy][:client_timeout] = '60s'
default[:haproxy][:server_timeout] = '60s'
default[:haproxy][:queue_timeout] = '120s'
default[:haproxy][:connect_timeout] = '10s'
default[:haproxy][:http_request_timeout] = '30s'

default[:haproxy][:global_max_connections] = '80000'
default[:haproxy][:default_max_connections] = '80000'
default[:haproxy][:retries] = '3'
default[:haproxy][:stats_socket_path] = '/tmp/haproxy.sock'
default[:haproxy][:stats_socket_level] = nil # nil for default or 'user', 'operator', 'admin'

default[:haproxy][:balance] = 'roundrobin'

