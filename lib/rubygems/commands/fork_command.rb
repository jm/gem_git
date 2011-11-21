class Gem::Commands::ForkCommand < Gem::Command
  include GemGit::Helper
  
  def initialize
    super 'fork', "Makes it easy to fork a gem's source repository for patching and enhancement."
  end

  def description # :nodoc:
    "Makes it easy to fork a gem's source repository for patching and enhancement."
  end
  
  def execute
    gem_name = get_one_optional_argument
    
    begin
      username, repository = github_info_for(gem_name)
    
      puts "Forking #{gem_name} from https://github.com/#{username}/#{repository}..."    
      response = Net::HTTP.post_form(URI("http://github.com/api/v2/json/repos/fork/#{username}/#{repository}"), 'login' => github_user, 'token' => github_token)
      
      response_code = response.code.to_i
      if response_code >= 400
        puts "Oops, seems there was an error (code #{response_code})."
        
        interpret_error(response_code)
      else
        puts "Repository forked, now cloning..."
        
        git("clone", "git@github.com:#{github_user}/#{repository}.git")
      end
    rescue NotOnGithubError
      puts "Sorry, this gem isn't hosted on Github.  You can always use `gem clone` and then push it to Github."
    rescue NoGithubCredentialsError
      puts "You don't have your username and token set in the global git config (run `git config --get github.user` to see what I mean)."
      puts "Please set those configuration values and try again."
    end
    
    super
  end
  
  def interpret_error(code)
    case code
    when 400
      puts "There was something wrong with the request it seems.  Please try again or file a bug with me on Github."
    when 404
      puts "Looks like the repository doesn't exist or was moved.  Check the URL in the RubyGems information."
    when 401
      puts "Sorry, looks like you don't have access to that repos or your credentials stored in the global git config are bad."
    when 500, 503
      puts "Github must be having some issues; try it again later?"
    else
      puts "Well I'm not sure what happened.  Give it another shot, and maybe it'll be fixed."
    end
  end
end