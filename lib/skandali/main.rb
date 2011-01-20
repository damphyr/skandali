require 'net/http'
require 'uri'

require 'patir/command'

module Skandali
  module Version
    MAJOR=0
    MINOR=0
    TINY=1
    STRING=[ MAJOR, MINOR, TINY ].join( "." )
  end
  #Parses the command line arguments
  def self.parse_command_line args
    rules_file=nil
    args.options do |opt|
      opt.on("Usage:")  
      opt.on("post-commit [options] repo_path revision")
      opt.on("Options:")
      opt.on("--debug", "-d","Turns on debug messages") { $DEBUG=true }
      opt.on("-v", "--version","Displays the version") { $stdout.puts("v#{Version::STRING}");exit 0 }
      opt.on("-r", "--rules FILE","reads the rules from the specified FILE") { |rf| rules_file=rf }
      opt.on("--help", "-h", "-?", "This text") { $stdout.puts opt; exit 0 }
      opt.parse!
      #and now the rest
      if args.empty?
        $stdout.puts opt 
        exit 0
      else
        repo_path=args.shift
        revision=args.shift
        return [repo_path,revision,rules_file]
      end
    end
  end
end
