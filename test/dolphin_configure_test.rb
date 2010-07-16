require 'test_helper'

class DolphinConfigureTest < Test::Unit::TestCase
  include FeatureContextHelper

  def setup
    Dolphin.send :clear!
  end

  def test_configuration
    Dolphin.configure do
      flipper(:admin) { true }
    end
  
    assert_not_nil 'admin', Dolphin.flippers['admin']
  end

  def test_default_flipper_on
    Dolphin::FeatureStore.update_feature(:test_feature, :on)
    context.use_feature

    assert_not_nil context.output
  end

  def test_default_flipper_off
    Dolphin::FeatureStore.update_feature(:test_feature, :off)
    context.use_feature

    assert_nil context.output
  end

end
