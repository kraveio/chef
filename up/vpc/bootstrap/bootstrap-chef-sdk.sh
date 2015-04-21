#!/bin/bash

sudo apt-get update
sudo apt-get install git -y

wget -O '/opt/bootstrap/chefdk.deb' 'https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.4.0-1_amd64.deb'; 
sudo dpkg -i '/opt/bootstrap/chefdk.deb'

echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile

# Berkshelf should be installed as well as chef at this point
sudo mkdir -p /var/chef/cache /var/chef/cookbooks

# Hostname
#wget -qO- https://supermarket.chef.io/cookbooks/hostnames/versions/0.3.1/download | sudo tar xvzC /var/chef/cookbooks

cd /opt/bootstrap/
sudo berks package bootstrap.tar.gz
sudo chef-solo -o 'recipe[hostnames]' -j '/opt/bootstrap/hostname.json' -r '/opt/bootstrap/bootstrap.tar.gz'

cd /opt/bootstrap/node/
sudo berks package node.tar.gz
sudo chef-solo -j '/opt/bootstrap/node/node.json' -r '/opt/bootstrap/node/node.tar.gz'


