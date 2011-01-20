require "test/unit"
require "rubygems"
require "mocha"
require "skandali/post_commit"

class TestPostCommit < Test::Unit::TestCase
  def test_load_rules
    cnt=YAML.dump([{:pattern=>"/some/",:actions=>[{:url=>"http://localhost/TRIGGER"},{:cmd=>"echo TRIGGER_CMD"},{:url=>"http://localhost/TRIGGER_BOTH",:cmd=>"echo TRIGGER"}]}])
    File.expects(:read).returns(cnt)
    post_commit_trigger=Skandali::PostCommit.new("rules_file_mock")
    assert_equal(1,post_commit_trigger.rules.size)
  end
end
