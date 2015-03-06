
include_recipe 'consul'

consul_service_def 'nginx' do
  port 80
  tags ['nginx']
  notifies :reload, 'service[consul]'
end
