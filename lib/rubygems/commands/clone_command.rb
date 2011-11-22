class Gem::Commands::CloneCommand < Gem::Command
  include GemGit::Helper
  
  def initialize
    super 'clone', "Clone a gem's source from its repository."
  end

  def description # :nodoc:
    "Clone a gem's source from its repository."
  end
  
  def execute
    gem_name = get_one_optional_argument
    
    url = repository_url_for(gem_name)
    puts "Cloning #{gem_name} from #{url}..."
    
    git "clone", url
    super
  end
end
