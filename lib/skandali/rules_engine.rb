module Skandali
  class RulesEngine
    attr_reader :patterns
    #rules is an Array of {:pattern=>/regexp/, :actions=>[]}
    #
    #Patterns are ruby regular expressions
    #
    #Actions triggered by rule matches can be url GET operations
    # :actions=>{:url=>"http://foo.bar/"}
    #or shell commands 
    # :actions=>{:cmd=>"sh trigger.sh"}
    def initialize rules
      load_rules(rules)
    end
    #Returns the actions of all rules triggered by token
    def trigger? token
      actions=[]
      @patterns.keys.each do |pattern|
        actions+=@patterns[pattern] if pattern=~token
      end
      return actions.uniq
    end
    def load_rules rules
      @patterns={}
      rules.each do |rule|
        @patterns[rule[:pattern]]||=[]
        @patterns[rule[:pattern]]+=rule[:actions]
      end
    end
  end
end