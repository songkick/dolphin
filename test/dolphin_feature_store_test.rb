require 'test_helper'

class DolphinStateTest < Test::Unit::TestCase
  include FeatureContextHelper

  def setup
    Dolphin.configure do
      flipper(:flipper_one) { request.env['CONDITION_FLAG'] }
      flipper(:flipper_two) { true }
    end
  end

  def teardown
    clear_feature_store_files
  end

  def test_skips_feature_before_state_saved
    context.use_feature
    assert_nil context.output
  end

  def test_uses_feature_after_state_saved
    Dolphin::FeatureStore.update_feature(:test_feature, :flipper_two)
    context.use_feature

    assert_not_nil context.output
  end

end
