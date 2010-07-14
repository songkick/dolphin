namespace :dolphin do

  desc "Apply a rule to a Dolphin feature.\nBoth rule and feature must be pre-configured in your app for this to have any effect."
  task :update_feature, :feature, :rule do |t, args|
    feature, rule = args[:feature], args[:rule]

    unless feature && rule
      puts "Need feature and rule. eg:\n\trake dolphin:update_feature[feature_name,rule_name]"
      exit 1
    end

    Dolphin::FeatureStore.update_feature(feature, rule)
  end

end
