require 'test_helper'

class DolphinHelperTest < Test::Unit::TestCase
  include FeatureContextHelper

  def setup
    Dolphin.configure do
      flipper(:test_flipper) { |request| request.env['CONDITION_FLAG'] }
    end
    Dolphin::FeatureStore.update_feature(:test_feature, :test_flipper)
  end

  def test_call_block_if_feature_flipper_met
    context.request.env['CONDITION_FLAG'] = true
    context.use_feature

    assert_not_nil context.output
  end

  def test_skip_block_if_feature_not_configured
    context.use_feature

    assert_nil context.output
  end

  def test_skip_block_if_feature_flipper_not_met
    context.use_feature

    assert_nil context.output
  end

  def test_skip_block_if_no_request
    context.no_request!
    context.use_feature

    assert_nil context.output
  end

end
