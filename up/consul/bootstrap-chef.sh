#!/bin/bash

# omnibus installer
curl -L https://www.chef.io/chef/install.sh | sudo bash

# create required bootstrap dirs/files
sudo mkdir -p /var/chef/cache /var/chef/cookbooks


## TODO connect to chef server and run default receipes

