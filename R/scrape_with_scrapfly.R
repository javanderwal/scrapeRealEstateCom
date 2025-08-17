scrape_with_scrapfly <- function(target_url, scrapfly_api_key) {
  
  scrapfly_base_url <- "https://api.scrapfly.io/scrape"
  
  query_params <- list(
    key = scrapfly_api_key,
    url = target_url,
    asp = "true",
    render_js = "true",
    country = "AU"
  )
  
  response <- httr::GET(url = scrapfly_base_url, query = query_params)
  
  if (httr::status_code(response) != 200) {
    stop(
      "ScrapFly API request failed with status: ", 
      httr::status_code(response),
      "\nResponse content:\n", 
      httr::content(response, "text", encoding = "UTF-8")
    )
  }
  
  response_data <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"))
  html_content <- response_data$result$content
  
  if (is.null(html_content)) {
    stop("Could not find HTML content in the ScrapFly response.")
  }
  
  parsed_html <- rvest::read_html(html_content)
  
  return(parsed_html)
}