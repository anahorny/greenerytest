module Screenshots
def screenshot
	currenttime=Time.new.to_i
	$browser.driver.save_screenshot "./out/screenshots/screenshot-#{currenttime}.png"
	embed "../screenshots/screenshot-#{currenttime}.png", 'image/png'
end
end
World(Screenshots)

