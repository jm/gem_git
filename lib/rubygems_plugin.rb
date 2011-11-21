require 'net/http'
require 'json'

require 'gem_git/helper'

require 'rubygems/command_manager'

Gem::CommandManager.instance.register_command :clone
Gem::CommandManager.instance.register_command :fork