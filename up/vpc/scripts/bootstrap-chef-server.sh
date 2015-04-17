#!/bin/bash

# install chef-solo
curl -L https://www.chef.io/chef/install.sh | sudo bash

# create required bootstrap dirs/files
sudo mkdir -p /var/chef/cache /var/chef/cookbooks

# pull down this chef-server cookbook
wget -qO- https://supermarket.chef.io/cookbooks/chef-server/download | sudo tar xvzC /var/chef/cookbooks

# pull down dependency cookbooks
wget -qO- https://supermarket.chef.io/cookbooks/chef-server-ingredient/download | sudo tar xvzC /var/chef/cookbooks
wget -qO- https://supermarket.chef.io/cookbooks/packagecloud/download | sudo tar xvzC /var/chef/cookbooks

wget -qO- https://supermarket.chef.io/cookbooks/hostnames/versions/0.3.1/download | sudo tar xvzC /var/chef/cookbooks

# GO GO GO!!!
sudo chef-solo -o 'recipe[chef-server::default]' #,recipe[hostnames]'
