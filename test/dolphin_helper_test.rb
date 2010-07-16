require 'test_helper'

class DolphinHelperTest < Test::Unit::TestCase
  include FeatureContextHelper

  def setup
    Dolphin.configure do
      flipper(:test_flipper) { request.env['CONDITION_FLAG'] }
    end
    Dolphin::FeatureStore.update_feature(:test_feature, :test_flipper)
  end

  def teardown
    clear_feature_store_files
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

  def test_do_not_explode_if_error_in_flipper
    assert_nothing_raised do
      suppress_errors do
        context_without_request.use_feature
      end
    end
  end

  def test_skip_block_if_error_in_flipper
    suppress_errors do
      context_without_request.use_feature
    end
    assert_nil context_without_request.output
  end

end
