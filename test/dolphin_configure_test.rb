require 'test_helper'

class DolphinConfigureTest < Test::Unit::TestCase

  def setup
    Dolphin.send :clear!
  end

  def test_configuration
    Dolphin.configure do
      flipper(:admin) { |request| true }
    end
  
    assert_not_nil 'admin', Dolphin.flippers['admin']
  end

end
