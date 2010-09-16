module Dolphin

  $LOAD_PATH << File.expand_path(File.dirname(__FILE__))
  require 'dolphin/dsl'
  require 'dolphin/helper'
  require 'dolphin/feature_store'

  class ConfigurationError < StandardError; end

  class << self

    def configure(&block)
      DSL.new(self, &block)
    end

    def flippers
      @flippers ||= default_flippers
    end

    def clear!
      @flippers = nil
      FeatureStore.clear!
    end

  private

    def default_flippers
      {
        'enabled'  => lambda { true },
        'disabled' => lambda { false }
      }
    end

  end

end
