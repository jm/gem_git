module GemGit
  module Helper
    class NotOnGithubError < StandardError
    end
  
    class NoGithubCredentialsError < StandardError
    end
  
    def git(*args)
      exec("git #{args.join(' ')}")
    end
  
    def github_user
      @github_user ||= `git config --get github.user`.chomp
    
      raise NoGithubCredentialsError.new if @github_user.empty?
      @github_user
    end
  
    def github_token
      @github_token ||= `git config --get github.token`.chomp
    
      raise NoGithubCredentialsError.new if @github_token.empty?
      @github_token
    end
  
    def github_info_for(gem_name)
      repository_url = repository_url_for(gem_name)
      parsed_url = URI.parse(repository_url)
    
      if parsed_url.host == "github.com"
        parsed_url.path.split("/").slice(1,2) # Stupid splitting
      else
        raise NotOnGithubError.new
      end
    end
  
    def repository_url_for(gem_name)
      JSON.parse(Net::HTTP.get('rubygems.org', "/api/v1/gems/#{gem_name}.json"))['source_code_uri']
    end
  
    def github_clone_url(user, repos)
      "git@github.com:#{user}/#{repos}.git"
    end
  end
end