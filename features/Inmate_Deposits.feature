  Feature: Inmate deposits

  Background:
    * I open a browser
    * I read the data from the spreadsheet
    * I navigate to the environment url

  Scenario: Find inmate and verify deposit amounts are correct
    * click "Continue as guest"
    * select "Colorado" from "state list"
    * select "Douglas County Colorado" from "facilities"
    * click "Continue"
    * click "Choose for Inmate Account"
    * enter "Inmate's name" into "Inmate's Name"
    * "Inmate's name" is displayed in "Inmate's search result"
    * click "Inmate's search result" with "Inmate's name"
    * click "Other amount"
    * "Inmate's name" is displayed in "Inmate's search result"
    * enter "150" into "Other amount"
    * "150 total" is displayed in "Grand Total amount"
    * click "Payment Summary"
    * "$150.00" is displayed in "Deposit Amount summary"
    * "150 fee" is displayed in "Regulatory Fees"
    * I take a screenshot
    * I wait 5 seconds

