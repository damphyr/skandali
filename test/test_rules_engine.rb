require "test/unit"
require "skandali/rules_engine"

class TestRulesEngine < Test::Unit::TestCase
  def test_engine
    rules=[{:pattern=>/some/,:actions=>[{:url=>"http://localhost/TRIGGER"},{:cmd=>"echo TRIGGER"},{:url=>"http://localhost/TRIGGER",:cmd=>"echo TRIGGER"}]},
    {:pattern=>/path/,:actions=>[{:url=>"http://localhost/TRIGGER"},{:cmd=>"echo TRIGGER"},{:url=>"http://localhost/TRIGGER",:cmd=>"echo TRIGGER"}]}]
    engine=nil
    assert_nothing_raised() { engine=Skandali::RulesEngine.new(rules) }
    assert_equal(2, engine.patterns.size)
    assert(engine.trigger?("some/path"), "Should have matched")
    assert(engine.trigger?("other/foo").empty?, "Shouldn't have matched")
    actions=engine.trigger?("some/path")
    assert_equal(3, actions.size)
    actions=engine.trigger?("foo/bar")
    assert_equal(0, actions.size)
  end
end
