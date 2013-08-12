maintainer        'Greg Fitzgerald'
maintainer_email  'greg@gregf.org'
license           'MIT'
description       'Installs/Configures minecraft server'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '0.3.0'
name              'minecraft'

recipe 'minecraft', 'Installs and configures minecraft server.'
recipe 'minecraft::mcrcon', 'Installs and configures mcrcon.'

%w{ runit java build-essential logrotate}.each do |dep|
  depends dep
end

%w{ debian ubuntu centos }.each do |os|
  supports os
end
