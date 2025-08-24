scrapeRealEstateCom::email_listings_spreadsheet(
  url_to_scrape = Sys.getenv("URL_FILTER"),
  scrapfly_api_key = Sys.getenv("SCRAPFLY_API_KEY"),
  email_from = Sys.getenv("SMTP_USER"),
  email_to = strsplit(Sys.getenv("EMAIL_TO"), ",")[[1]],
  email_host = "smtp.gmail.com",
  email_port = 587,
  email_username = Sys.getenv("SMTP_USER"),
  email_password = Sys.getenv("SMTP_PASSWORD")
)
