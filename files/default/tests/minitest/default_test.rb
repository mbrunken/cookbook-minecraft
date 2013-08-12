require 'minitest/spec'
#
## Cookbook Name:: minecraft 
## Spec:: default

describe_recipe 'minecraft::default' do
  it 'ensures minecraft is installed' do
    file('/srv/minecraft/minecraft_server.jar').must_exist
  end

  it 'ensures a config file is present' do
    file('/srv/minecraft/server.properties').must_exist
  end

  it 'should have proper permissions' do
    assert_directory '/srv/minecraft', 'minecraft', 'minecraft', '755'
    assert_file '/srv/minecraft/minecraft_server.jar', 'minecraft', 'minecraft', '644'
  end

  it 'ensures minecraft is running' do
    service('minecraft').must_be_running
  end
end
