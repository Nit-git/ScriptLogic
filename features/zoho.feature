Feature: Zoho

  Background:
    * I open a browser
    * I read the data from the spreadsheet
   	* I go to the url "www.zoho.com\login.html"
	
	Scenario: Zoho
    * enter "email" into "Email Address"
	* enter "password" into "Password"
	* "text_SignIn" is displayed in "signIn_buttonText"
	* unselect "Keep me signed in"
	# * I click the "Sign In" if on "Sign in to your Zoho Account" page
	* I wait 3 seconds
	* click "Sign In"
	# * I wait 3 seconds
	# * click "SalesIQ"
	# * click "Time Zone"
	# * click "Zone selection"
	# * let me debug
	# * click "Calendar"	
