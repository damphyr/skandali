require 'skandali/rules_engine'
module Skandali
  PRE_COMMIT_TEMPLATE=<<-EOT
    #!/usr/bin/env ruby
    require 'rubygems'
    require 'skandali/main'
    
    repo_path,transaction,rules_file=*Skandali.parse_command_line(ARGV)

    if repo_path && transaction
      begin
        Skandali::PreCommit.new.pull(repo_path,transaction)
      rescue SkandaliError
        $stderr.puts($!.message)
        exit 1
      end
    end
  EOT
  
  class HookScriptError<RuntimeError
  end
  class PreCommit
    def pull repo_path,transaction
      if repo_path && transaction
        #get the log
        log_cmd=Patir::ShellCommand.new(:cmd=>"svnlook log #{repo_path} -t #{transaction}")
        log_cmd.run
        log=log_cmd.output.chomp
        raise HookScriptError,"Empty commit message" if !log || log.empty? 
      else
       raise HookScriptError,"No path or transaction number provided"
      end
    end
  end
end