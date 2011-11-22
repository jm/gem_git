require 'spec_helper'
require './lib/gem_git/helper'

class GemGitTester
  include GemGit::Helper
end


describe GemGit::Helper do

  before(:each) do
    @gem_git_helper = GemGitTester.new
  end

  describe "git" do
    it "should join the arguments" do
      @gem_git_helper.should_receive(:exec).with("git pull origin master")
      @gem_git_helper.git(["pull", "origin", "master"])
    end
  end

  describe "github_user" do
    it "should return the user if it is set" do
      @gem_git_helper.should_receive(:`).with("git config --get github.user").and_return("GithubUser")
      @gem_git_helper.github_user.should eql("GithubUser") 
    end

    it "should raise an error if the user is not found" do
      @gem_git_helper.should_receive(:`).with("git config --get github.user").and_return("\n")
      expect {
        @gem_git_helper.github_user
      }.to raise_error(GemGit::Helper::NoGithubCredentialsError)
    end
  end

  describe "github_token" do
    it "should return the token if it is set" do
      @gem_git_helper.should_receive(:`).with("git config --get github.token").and_return("secret_token")
      @gem_git_helper.github_token.should eql("secret_token") 
    end

    it "should raise an error if the user is not found" do
      @gem_git_helper.should_receive(:`).with("git config --get github.token").and_return("\n")
      expect {
        @gem_git_helper.github_token
      }.to raise_error(GemGit::Helper::NoGithubCredentialsError)
    end
  end

  describe "github_info_for" do
    it "should return the url if it receives a github url" do
      @gem_git_helper.should_receive(:repository_url_for).with("test_gem").and_return("http://github.com/username/test")
      @gem_git_helper.github_info_for("test_gem").should eql(["username", "test"])
    end
    
    it "should raise an error if it does not receive a github url" do
      @gem_git_helper.should_receive(:repository_url_for).with("test_gem").and_return("http://notvalid.com")
      expect {
        @gem_git_helper.github_info_for("test_gem")
      }.to raise_error(GemGit::Helper::NotOnGithubError)
    end
  end

  describe "repository_url_for" do
    it "should try and retrieve the gem from rubygems.org" do
      JSON.stub(:parse).and_return({})
      Net::HTTP.should_receive(:get).with("rubygems.org", "/api/v1/gems/test_gem.json").and_return()
      @gem_git_helper.repository_url_for("test_gem")
    end
  end

  describe "github_clone_url" do
    it "should return a git repository url" do
      @gem_git_helper.github_clone_url("test_user", "test_repository").should eql("git@github.com:test_user/test_repository.git")
    end
  end
end
