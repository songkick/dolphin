require 'test/unit'
require 'tempfile'

require File.expand_path('../lib/dolphin', File.dirname(__FILE__))

TEST_FEATURE_STORE_PATH = File.expand_path('files', File.dirname(__FILE__))
Dolphin::FeatureStore.send(:custom_feature_path=, TEST_FEATURE_STORE_PATH)

module FeatureContextHelper
  class FeatureContext
    include Dolphin::Helper

    def use_feature
      feature :test_feature do
        @output = 'MMM, TUNA'
      end
    end

    def output
      @output
    end
  end

  class FeatureContextWithRequest < FeatureContext
    class Request
      def env
        @env ||= {}
      end
    end

    def request
      @request ||= Request.new
    end

  end

  def context
    @context ||= FeatureContextWithRequest.new
  end

  def context_without_request
    @context_without_request ||= FeatureContext.new
  end

end

def clear_feature_store_files
  features_file = File.join(TEST_FEATURE_STORE_PATH, 'features.yml')
  File.delete(features_file) if File.exist?(features_file)
end

def suppress_errors(&block)
  file     = Tempfile.new('suppress_errors')
  original = STDERR.dup

  begin
    STDERR.reopen(file)
    block.call
  rescue
    file.flush
    raise
  ensure
    STDERR.reopen(original)
  end
end
