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
        'enabled'     => lambda { |*args| true },
        'disabled'    => lambda { |*args| false },
        'chance_1pc'  => lambda { |*args| rand < 0.01 },
        'chance_2pc'  => lambda { |*args| rand < 0.02 },
        'chance_5pc'  => lambda { |*args| rand < 0.05 },
        'chance_10pc' => lambda { |*args| rand < 0.1 },
        'chance_20pc' => lambda { |*args| rand < 0.2 },
        'chance_50pc' => lambda { |*args| rand < 0.5 }
      }
    end
  end
end
