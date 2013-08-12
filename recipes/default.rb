#
# Cookbook Name:: minecraft
# Recipe:: default
#
# Copyright 2012, Greg Fitzgerald
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

include_recipe 'runit'
include_recipe 'java::default'
include_recipe 'logrotate'

jar_name = "#{node['minecraft']['jar']}.#{node['minecraft']['version']}.jar"
minecraft_jar = "#{Chef::Config['file_cache_path']}/minecraft_server.jar"
uid = default['minecraft']['user']
gid = default['minecraft']['group']

node.default['minecraft']['jar_name'] = jar_name

user uid do
  system true
  comment 'Minecraft Server'
  home node['minecraft']['install_dir']
  shell '/bin/false'
  action :create
end

source_url = "#{node['minecraft']['base_url']}/#{node['minecraft']['version']}/#{jar_name}"
log "Using #{jar_name}, stored locally as #{minecraft_jar} and fetched from #{source_url}"

remote_file minecraft_jar do
  source "#{source_url}"
  checksum node['minecraft']['checksum']
  owner uid
  group gid
  mode '0644'
  action :create_if_missing
end

directory node['minecraft']['install_dir'] do
  owner uid
  group gid
  mode '0755'
  action :create
  recursive true
end

execute 'copy-minecraft_server.jar' do
  cwd node['minecraft']['install_dir']
  command "cp -p #{minecraft_jar} ."
  creates "#{node['minecraft']['install_dir']}/#{jar_name}"
end

%w[ops.txt server.properties banned-ips.txt
   banned-players.txt white-list.txt].each do |template|
  template "#{node['minecraft']['install_dir']}/#{template}" do
    source "#{template}.erb"
    owner uid
    group gid
    mode 0644
    action :create
    notifies :restart, 'runit_service[minecraft]' if node['minecraft']['auto_restart']
  end
end

runit_service "minecraft"

service 'minecraft' do
  supports :status => true, :restart => true, :reload => true
  reload_command "#{node['runit']['sv_bin']} hup #{node['runit']['service_dir']}/minecraft"
end

logrotate_app "minecraft" do
  cookbook "logrotate"
  path "#{node['minecraft']['install_dir']}/server.log"
  frequency node['minecraft']['logrotate']['frequency']
  rotate node['minecraft']['logrotate']['rotate']
  create "644 #{uid} #{gid}"
end

if node['minecraft']['use_rcon']
  include_recipe 'minecraft::mcrcon'
end
