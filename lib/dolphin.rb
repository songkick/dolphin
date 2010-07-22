module Dolphin

  $LOAD_PATH << File.expand_path(File.dirname(__FILE__))
  require 'dolphin/dsl'
  require 'dolphin/helper'
  require 'dolphin/feature_store'

  class << self

    def configure(&block)
      DSL.new(self, &block)
    end

    def flippers
      @flippers ||= default_flippers
    end

  private

    def default_flippers
      {
        'enabled'  => lambda { true },
        'disabled' => lambda { false }
      }
    end

    def clear!
      @flippers = nil
    end

  end

end
