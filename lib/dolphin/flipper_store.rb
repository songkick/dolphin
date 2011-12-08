module Dolphin
  class MissingFlipperError < StandardError; end

  class FlipperStore
    class DSL
      def initialize(store, &block)
        @store = store
        instance_eval(&block)
      end
      
      def flipper(name, &block)
        raise unless block_given?
        @store.set_flipper(name, block)
      end
    end
    
    def initialize
      @flipper_store = FlipperStore.default_flippers
    end
    
    def set_flipper(name, block)
      @flipper_store[name.to_s] = block
    end
    
    def [](name)
      @flipper_store[name.to_s]
    end
    
    def to_hash
      @flipper_store
    end

    def self.default_flippers
      @default_flippers ||= {
        'enabled'  => lambda { true },
        'disabled' => lambda { false }
      }
    end
  end
end
