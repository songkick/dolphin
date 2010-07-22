Given /^I have the following features:$/ do |table|
  table.hashes.each do |row|
    feature, flipper = row['name'], row['flipper']
    Given %Q{I set the flipper for feature "#{feature}" to "#{flipper}"}
  end
end

When /^I set the flipper for feature "([^"]*)" to "([^"]*)"$/ do |feature_name, flipper_name|
  Dolphin::FeatureStore.update_feature(feature_name, flipper_name)
end
