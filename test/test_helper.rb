require 'test/unit'

require File.expand_path('../lib/dolphin', File.dirname(__FILE__))

TEST_FEATURE_STORE_PATH = File.expand_path('files', File.dirname(__FILE__))
Dolphin::FeatureStore.send(:custom_feature_path=, TEST_FEATURE_STORE_PATH)

module FeatureContextHelper
  class FeatureContext
    include Dolphin::Helper

    class Request
      def env
        @env ||= {}
      end
    end

    def no_request!
      @request = nil
    end

    def request
      @request ||= Request.new
    end

    def use_feature
      feature :test_feature do
        @output = 'MMM, TUNA'
      end
    end

    def output
      @output
    end

  end

  def context
    @context ||= FeatureContext.new
  end

end
