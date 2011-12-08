module Dolphin
  
  # Given a feature name, this uses the global Dolphin::FeatureStore to go
  # to a flipper (a block), which it then evaluates to determine if it is 
  # available
  module Helper

    def feature(name, partial_options = {})
      return nil unless feature?(name)

      if partial_options[:partial] && respond_to?(:render)
        render partial_options
      elsif block_given?
        yield
      end
    end

    def feature?(name)
      Dolphin.feature_available?(name)
    end

  end
end
