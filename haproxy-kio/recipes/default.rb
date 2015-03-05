#
# Cookbook Name:: haproxy-kio
# Recipe:: default
#
# Copyright (C) 2015 Franklin Wise
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'haproxy::install'
include_recipe 'haproxy-kio::configure-initial'
include_recipe 'haproxy-kio::configure'
include_recipe 'haproxy::service'
