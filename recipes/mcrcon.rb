#
# Cookbook Name:: minecraft
# Recipe::mcrcon
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

include_recipe 'build-essential'

bin_path = node['minecraft']['mcrcon']['bin_path']
version = node['minecraft']['mcrcon']['version']


unless FileTest.exists?(File.join(bin_path, "mcrcon"))
  package 'unzip' do
    action :install
  end

  remote_file "mcrcon" do
    path "#{Chef::Config[:file_cache_path]}/mccron.zip"
    source "http://downloads.sourceforge.net/project/mcrcon/#{version}/mcrcon-#{version}-src.zip"
  end

  execute "extract-mcrcon" do
    command "cd #{Chef::Config[:file_cache_path]} && unzip mcrcon.zip"
    creates "#{Chef::Config[:file_cache_path]}/mccron-#{version}-src"
  end

  execute "install-mcrcon" do
    command "cd #{Chef::Config[:file_cache_path]}/mcrcon-#{version}-src && gcc mcrcon.c -o mcrcon && cp mcrcon #{bin_path}"
  end
end
