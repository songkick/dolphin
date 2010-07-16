module Dolphin
  class MissingFlipperError < StandardError; end

  class DSL

    def initialize(flipper_store, &block)
      @flipper_store = flipper_store
      instance_eval(&block)
    end

    def flipper(name, &block)
      raise unless block_given?
      @flipper_store.flippers[name.to_s] = block
    end

  end
end
