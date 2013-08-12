require 'minitest/spec'
#
## Cookbook Name:: minecraft
## Spec:: mcrcon

describe_recipe 'minecraft::mcrcon' do
  it 'ensures mcrcon is installed' do
    file('/usr/local/bin/mcrcon').must_exist
  end

  it 'should have proper permissions' do
    assert_file '/usr/local/bin/mcrcon', 'root', 'root', '755'
  end

  it 'ensures we can run mcrcon' do
    result = assert_sh("/usr/local/bin/mcrcon -h")
    assert_includes result, "Usage: mcrcon"
  end

  describe 'ensures rcon is enabled on the server' do
    let(:config) { file("#{node['minecraft']['install_dir']}/server.properties") }
    it { config.must_include 'enable-rcon=true' }
  end
end
