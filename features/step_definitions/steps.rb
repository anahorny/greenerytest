# Examples:
# Given I am on the "home_page"
# Given I am on the "configuration_page"
Given /I am on the "(.*)"/ do |page_name|
	wait { $browser.goto $props.get_env(page_name) }
end

# Examples:
# When I set "cucumber github" in "Search field" of "Home page"
# When I select "English" in "Language combobox" of "Home page"
When /I (.*) "(.*)" in "(.*)" of "(.*)"/ do |action, value, object, page|
	wait { $props.make('action'=>action, 'value'=>value, 'object'=>object, 'page'=>page) }
end

# Examples:
# When I click "Start button" on "Home page"
# When I set "Log checkbox" on "Configuration page"
# When I clear "Log checkbox" on "Configuration page"
When /I (.*) "(.*)" on "(.*)"/ do |action, object, page|
	wait { $props.make('action'=>action, 'object'=>object, 'page'=>page) }
end

# Examples:
# I should see "OK" text in "Status field" of "Home page"
Then /I should see "(.*)" text in "(.*)" of "(.*)"/ do |value, object, page|
	wait { $props.make('object'=>object, 'page'=>page).text.include?(value).should == true }
end

# Examples:
# When I set the following objects on "Home page"
#   |checkbox1|
#   |checkbox2|
When /I (.*) the following objects on "(.*)"/ do |action, page, elems|
    elems.hashes[0].each_key do |value|
		wait { $props.make('action'=>action, 'object'=>value, 'page'=>page) }
    end
  	elems.hashes.each do |hash|		
    hash.each_value do |value|
		wait { $props.make('action'=>action, 'object'=>value, 'page'=>page) }
    end
  	end	
end

# Examples:
# Then I should see "GitHub" text on the screen
Then /I should see "(.*)" text on the screen/ do |value|
	wait { $browser.text.include?(value).should == true }
end

# Examples:
# I should see the following values on "Home page"
#   |text1|
#   |text2|
Then /I should see the following values on "(.*)"/ do |object, page, elems|
    elems.hashes[0].each_key do |value|
		wait { $browser.text.include?(value).should == true }	
    end
  	elems.hashes.each do |hash|		
    hash.each_value do |value|
		wait { $browser.text.include?(value).should == true }	
    end
  	end	
end

# Examples:
# I should see the following values in "Some frame" of "Home page"
#   |text1|
#   |text2|
Then /I should see the following values in "(.*)" of "(.*)"/ do |object, page, elems|
    elems.hashes[0].each_key do |value|
		wait { $props.make('object'=>object, 'page'=>page).text.include?(value).should == true }	
    end
  	elems.hashes.each do |hash|		
    hash.each_value do |value|
		wait { $props.make('object'=>object, 'page'=>page).text.include?(value).should == true }	
    end
  	end	
end

