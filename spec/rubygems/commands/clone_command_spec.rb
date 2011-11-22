require 'spec_helper'
require 'rubygems/command_manager'
require './lib/gem_git/helper'
require './lib/rubygems/commands/clone_command'

describe Gem::Commands::CloneCommand do

  before(:each) do
    @clone_command = Gem::Commands::CloneCommand.new
  end

  describe "execute" do
    it "should clone the gem" do
      pending "I have no idea how to stub super!"
      @clone_command.stub(:get_one_optional_argument).and_return("test_gem")
      @clone_command.should_receive(:repository_url_for).with("test_gem").and_return("http://github.com/user/gem")
      @clone_command.should_receive(:git).with("clone", "http://github.com/user/gem")
      @clone_command.execute
    end
  end
end
