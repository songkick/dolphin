require 'fileutils'
require 'yaml'

require 'dolphin/helper'
require 'dolphin/feature_store'
require 'dolphin/flipper_store'
  
module Dolphin

  def self.configure(&block)
    FlipperStore::DSL.new(flipper_store, &block)
  end

  def self.flipper_store
    @flipper_store ||= FlipperStore.new
  end

  def self.feature_store
    @feature_store
  end
  
  def self.init(feature_file)
    @feature_store = FeatureStore.new(feature_file)
  end

  def self.feature_available?(name)
    if flipper_name = feature_store[name]
      if flipper = flipper_store[flipper_name]
        instance_eval(&flipper)
      else
        false
      end
    else
      false
    end
  end

  def self.clear
    @flippers = nil
    @feature_store = nil
    @flipper_store = nil
  end
end
