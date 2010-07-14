require 'test_helper'

class DolphinConfigureTest < Test::Unit::TestCase

  def setup
    Dolphin.send :clear!
  end

  def test_configuration
    Dolphin.configure do
      rule(:admin) { |request| true }
      feature :admin_feature, :admin
    end
  
    assert_equal 'admin', Dolphin.features['admin_feature']
  end

  def test_configuring_feature_fails_without_rule
    assert_raise Dolphin::MissingRuleError do
      Dolphin.configure do
        feature :admin_feature, :admin
      end
    end
  end

end
