Feature: Search
	In order to learn more
	As an information seeker
	I want to find more information

Scenario: Find what I'm looking for
	Given I am on the "home_page"
	When I set "cucumber github" in "Search field" of "Home page"
	When I click "Search button" on "Home page"
	Then I should see "GitHub" text on the screen
	When I click "konnichiwa" on "Home page"

