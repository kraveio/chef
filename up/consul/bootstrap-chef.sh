#!/bin/bash

# omnibus installer
curl -L https://www.chef.io/chef/install.sh | sudo bash

# create required bootstrap dirs/files
sudo mkdir -p /var/chef/cache /var/chef/cookbooks

# pull down berkshelf cookbook
#wget -qO- https://supermarket.chef.io/cookbooks/berkshelf/download | sudo tar xvzC /var/chef/cookbooks

# pull down dependency cookbooks
#wget -qO- https://supermarket.chef.io/cookbooks/rbenv/download | sudo tar xvzC /var/chef/cookbooks
#wget -qO- https://supermarket.chef.io/cookbooks/gecode/download | sudo tar xvzC /var/chef/cookbooks
#sudo chef-solo -o 'recipe[berkshelf::default]'

wget -qO- https://github.com/gotchef/consul-got/releases/download/0.1.2/consul-got_v0.1.2.tar.gz | sudo tar xvzC /var/chef/cookbooks

# run berkshelf recipe
sudo chef-solo -o 'recipe[consul-got::server]'

# TODO: copy Berksfile of cook book we want

#curl -L https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.4.0-1_amd64.deb | sudo bash

