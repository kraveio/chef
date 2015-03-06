include_recipe 'consul'

consul_service_def 'haproxy' do
  port 80
  tags ['lb']
  notifies :reload, 'service[consul]'
end
