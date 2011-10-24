begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end

# Do not forget to include the path to the respective classes in the RUBYLIB environment variable for the following statements to work correctly
require 'props'
require 'helpers'
require 'watir-webdriver'

# "before all"
case ENV['WBROWSER']
when 'ff'
	browser = Watir::Browser.new :firefox
when 'chrome'
	browser = Watir::Browser.new :chrome
when 'ie'
	browser = Watir::Browser.new :ie
when 'headless'
	require 'headless'
	headless = Headless.new
	headless.start
	browser = Watir::Browser.start
else
	raise "This browser is not supported, supported browsers are: ff, chrome, ie and headless"
end

# Creating the instance of the class that provides access to the global properties and object mapping files (namely properties.xml and mappings.xml)
$props = Props.new

Before do
	$browser = browser
end

AfterStep do
	# Latency after each step
	begin
		sleep $props.get_env("latency").to_i
	rescue 
	end
end

After do |scenario|
	screenshot if scenario.failed?
end

# "after all"
at_exit do
	headless.destroy if ENV['WBROWSER']=='headless'
	browser.close
end

