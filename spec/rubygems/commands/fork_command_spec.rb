require 'spec_helper'
require 'rubygems/command_manager'
require './lib/gem_git/helper'
require './lib/rubygems/commands/fork_command'

describe Gem::Commands::ForkCommand do

  before(:each) do
    @fork_command = Gem::Commands::ForkCommand.new
  end

  describe "execute" do
    it "should fork the gem" do
      pending "I have no idea how to stub super!"
    end
  end
end
