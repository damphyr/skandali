require "test/unit"
require "rubygems"
require "mocha"
require 'patir/command'
require "skandali/post_commit"

class TestPostCommit < Test::Unit::TestCase
  def test_load_rules
    cnt=YAML.dump([{:pattern=>/src/,:actions=>[{:url=>"http://localhost/TRIGGER"},{:cmd=>"echo TRIGGER_CMD"},{:url=>"http://localhost/TRIGGER_BOTH",:cmd=>"echo TRIGGER"}]}])
    File.expects(:read).returns(cnt)
    post_commit_trigger=Skandali::PostCommit.new("rules_file_mock")
    assert_equal(1,post_commit_trigger.rules.size)
  end
  
  def test_target
    cnt=YAML.dump([{:pattern=>/src/,:actions=>[{:url=>"http://localhost/TRIGGER"},{:cmd=>"echo TRIGGER_CMD"},{:url=>"http://localhost/TRIGGER_BOTH",:cmd=>"echo TRIGGER"}]}])
    File.expects(:read).returns(cnt)
    cmd_mock=mock()
    Patir::ShellCommand.expects(:new).returns(cmd_mock)
    cmd_mock.expects(:run).returns()
    cmd_mock.expects(:output).returns("U src/code\nA doc/foo")
    
    post_commit_trigger=Skandali::PostCommit.new("rules_file_mock")
    Net::HTTP.expects(:start).times(2)
    Patir::ShellCommand.expects(:new).returns(cmd_mock).times(2)
    cmd_mock.expects(:run).returns().times(2)
    assert_nothing_raised() { post_commit_trigger.pull("src/code/foo","10") }
  end
  #this one tests that when a GET is done and fails everything proceeds as normal
  def test_target_fail
    cnt=YAML.dump([{:pattern=>/src/,:actions=>[{:url=>"http://localhost/TRIGGER"}]}])
    File.expects(:read).returns(cnt)
    cmd_mock=mock()
    Patir::ShellCommand.expects(:new).returns(cmd_mock)
    cmd_mock.expects(:run).returns()
    cmd_mock.expects(:output).returns("U src/code\nA doc/foo")
    
    post_commit_trigger=Skandali::PostCommit.new("rules_file_mock")
    assert_nothing_raised() { post_commit_trigger.pull("src/code/foo","10") }
  end
end
