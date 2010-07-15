module Dolphin

  $LOAD_PATH << File.expand_path(File.dirname(__FILE__))
  require 'dolphin/dsl'
  require 'dolphin/helper'
  require 'dolphin/feature_store'

  class << self

    def configure(&block)
      DSL.new(self, &block)
    end

    def features
      @features ||= {}
    end

    def flippers
      @flippers ||= {}
    end

  private

    def clear!
      @features = {}
      @flippers    = {}
    end

  end

end
