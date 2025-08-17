#' Email a Spreadsheet Containing realestate.com listings data
#'
#' @description
#' Scrape a realestate.com webpage and email a spreadsheet with the contents
#' to a specified email address.
#' the contents of a supplied
#'
#' @param url_to_scrape A string containing the full URL of the web page to scrape.
#' @param scrapfly_api_key A string containing your API key for the Scrapfly service.
#' @param email_from A string specifying the sender's email address (e.g., `"sender@example.com"`).
#' @param email_to A string specifying the recipient's email address (e.g., `"recipient@example.com"`).
#' @param email_host A string for the SMTP server's hostname (e.g., `"smtp.gmail.com"`).
#' @param email_port A numeric value for the SMTP server's port (e.g., `587`).
#' @param email_username A string for the username to authenticate with the SMTP server.
#' @param email_password A string for the password or app-specific token to authenticate with the SMTP server.
#'
#' @return Returns the SMTP server's response object from the `emayili` package,
#'   which can be used to confirm successful delivery or debug issues.
#'
#' @importFrom emayili envelope from to subject text attachment server
#' @importFrom tools file_path_sans_ext
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # This example requires a valid Scrapfly API key and SMTP credentials.
#'
#' email_listings_spreadsheet(
#'   url_to_scrape = "https://www.example-news.com/articles",
#'   scrapfly_api_key = "YOUR_SCRAPFLY_API_KEY",
#'   email_from = "your_email@gmail.com",
#'   email_to = "colleague@work.com",
#'   email_host = "smtp.gmail.com",
#'   email_port = 587,
#'   email_username = "your_email@gmail.com",
#'   email_password = "YOUR_GMAIL_APP_PASSWORD"
#' )
#' }

email_listings_spreadsheet <-
  function(url_to_scrape,
           scrapfly_api_key,
           email_from,
           email_to,
           email_host,
           email_port,
           email_username,
           email_password) {
    spreadsheet_path <- create_listing_spreadsheet(url_to_scrape, scrapfly_api_key)

    email <-
      emayili::envelope() |>
      emayili::from(email_from) |>
      emayili::to(email_to) |>
      emayili::subject(stringr::str_glue("Current realestate.com listings - {format(Sys.Date(), '%d-%b-%Y')}")) |>
      emayili::text("Please find attached realestate.com's current listings.") |>
      emayili::attachment(spreadsheet_path)

    smtp <-
      emayili::server(
        host = email_host,
        port = email_port,
        username = email_username,
        password = email_password
      )

    smtp(email)
  }
