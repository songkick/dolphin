namespace :dolphin do

  desc "Apply a flipper to a Dolphin feature.\nBoth flipper and feature must be pre-configured in your app for this to have any effect."
  task :update_feature, :feature, :flipper do |t, args|
    feature, flipper = args[:feature], args[:flipper]

    unless feature && flipper
      puts "Need feature and flipper. eg:\n\trake dolphin:update_feature[feature_name,flipper_name]"
      exit 1
    end

    Dolphin::FeatureStore.update_feature(feature, flipper)
  end

end
