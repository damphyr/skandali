require 'skandali/rules_engine'
module Skandali
  POST_COMMIT_TEMPLATE=<<-EOT
    #!/usr/bin/env ruby
    require 'rubygems'
    require 'skandali/main'
    
    repo_path,revision,rules_file=*Skandali.parse_command_line(ARGV)

    rules_file ||= <%= rules_file>

    if repo_path && revision
      Skandali::PostCommit.new(rules_file).pull(repo_path,revision)
    end
  EOT
  
  class PostCommit
    attr_reader :rules
    def initialize rules_file
      @rules=load_rules(rules_file)
      @engine=Skandali::RulesEngine.new(rules)
    end
    #Loads the ammo (the rules)
    def load_rules rules_file
      @rules=YAML.load(File.read(rules_file))
      @engine.load_rules(rules) if @engine
      return @rules
    end
    #Pulls the trigger
    def pull repo_path,revision
      #get the changeset
      #changes=
      #find out which actions need to be triggered
      actions=[]
      changes.each do |change|
        actions+=engine.trigger?
      end
      #and trigger them
      actions.each do |action|
        if action[:url]
          url = URI.parse(action[:url])
          res = Net::HTTP.start(url.host, url.port) {|http| http.get(url.path)}
        end
        if action[:cmd]

        end
      end
    end
  end
end