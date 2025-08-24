scrapeRealEstateCom::email_listings_spreadsheet(
  url_to_scrape = "https://www.realestate.com.au/buy/property-unit+apartment-with-2-bedrooms-in-nunawading,+vic+3131%3b+blackburn,+vic+3130%3b+mitcham,+vic+3132%3b+box+hill,+vic+3134%3b+vermont,+vic+3133%3b+forest+hill,+vic+3131%3b+box+hill+north,+vic+3129/list-1?numParkingSpaces=1&numBaths=1&maxBeds=2&keywords=single%20storey&checkedFeatures=single%20storey&activeSort=list-date&sourcePage=rea:buy:srp-map&sourceElement=tab-headers",
  scrapfly_api_key = Sys.getenv("SCRAPFLY_API_KEY"),
  email_from = Sys.getenv("SMTP_USER"),
  email_to = strsplit(Sys.getenv("EMAIL_TO"), ",")[[1]],
  email_host = "smtp.gmail.com",
  email_port = 587,
  email_username = Sys.getenv("SMTP_USER"),
  email_password = Sys.getenv("SMTP_PASSWORD")
)
