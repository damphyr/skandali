require "test/unit"
require "rubygems"
require "mocha"
require 'patir/command'
require "skandali/pre_commit"

class TestPostCommit < Test::Unit::TestCase
  def test_pull
    cmd_mock=mock()
    Patir::ShellCommand.expects(:new).returns(cmd_mock).times(2)
    cmd_mock.expects(:run).returns().times(2)
    cmd_mock.expects(:output).returns("")
    
    assert_raise(Skandali::HookScriptError) {  Skandali::PreCommit.new.pull("repo_path","transaction") }
    cmd_mock.expects(:output).returns("something")
    assert_nothing_raised(Skandali::HookScriptError) {  Skandali::PreCommit.new.pull("repo_path","transaction") }
  end
end
