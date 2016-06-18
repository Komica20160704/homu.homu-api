require_relative "../Domain/UndeadWorld/Application"
require "test/unit"

class TestUndeadWorld < Test::Unit::TestCase
  def setup
    @undead_world = UndeadWorld::Application.new
  end

  def teardown
    # Empty
  end

  def test_sing_in
    @undead_world.sing_in 'mickplayer', ''
  end
end
