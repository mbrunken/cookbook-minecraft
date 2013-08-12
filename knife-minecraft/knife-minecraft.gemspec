# -*- encoding: utf-8 -*-
require File.expand_path('../lib/knife-minecraft/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = "knife-minecraft"
  gem.version = Knife::Minecraft::VERSION
  gem.authors = ["Greg Fitzgerald"]
  gem.email = ["greg@gregf.org"]
  gem.description = %q{Knife plugin and Chef cookbook for managing minecraft servers.}
  gem.summary = %q{Provides a chef cookbook to manage a minecraft server. Includes a knife plugin for managing minecraft over rcon.}
  gem.homepage = "https://github.com/gregf/chef-minecraft"
  gem.licenses = ["APACHE"]

  gem.files = Dir['lib/**/*.rb'] + Dir['bin/*']
  gem.files += Dir['[A-Z]*'] + Dir['test/**/*']
  gem.files += Dir['*\.gemspec']
  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})

  gem.add_dependency "chef", ">= 0.10.10"

  gem.require_paths = ["lib"]
end
