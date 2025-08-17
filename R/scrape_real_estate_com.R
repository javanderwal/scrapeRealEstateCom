scrape_real_estate_com <- function(url_to_scrape, scrapfly_api_key) {
  first_page_html <- scrape_with_scrapfly(url_to_scrape, scrapfly_api_key)

  number_of_pages <-
    first_page_html |>
    rvest::html_elements(".styles__PageNumberContainer-sc-1tm2eg4-1") |>
    rvest::html_elements("a") |>
    rvest::html_text() |>
    as.numeric()

  first_page_content <-
    first_page_html |>
    rvest::html_elements('[data-testid="ResidentialCard"]')

  pages_to_iterate_through <- number_of_pages[number_of_pages > 1]

  additional_pages <-
    purrr::map(
      .x = pages_to_iterate_through,
      .f = iterate_realestate_com,
      url_to_scrape, scrapfly_api_key
    )

  combined_xml_nodes <-
    purrr::flatten(
      list(
        first_page_content,
        purrr::flatten(additional_pages)
      )
    )

  purrr::map(
    .x = combined_xml_nodes,
    .f = get_card_content
  ) |>
    dplyr::bind_rows()
}

iterate_realestate_com <- function(page_num, url_to_scrape, scrapfly_api_key) {
  new_url <-
    stringr::str_replace(
      string = url_to_scrape,
      pattern = "/list-1?",
      replacement = stringr::str_glue("/list-{page_num}?")
    )

  page_html <-
    scrape_with_scrapfly(new_url, scrapfly_api_key) |>
    rvest::html_elements('[data-testid="ResidentialCard"]')

  return(page_html)
}

get_card_content <- function(combined_xml_nodes) {
  card_title <-
    combined_xml_nodes |>
    rvest::html_nodes(".residential-card__title") |>
    rvest::html_text()

  card_description <-
    combined_xml_nodes |>
    rvest::html_nodes(".residential-card__address-heading") |>
    rvest::html_text()

  card_indicative_price <-
    combined_xml_nodes |>
    rvest::html_elements("div.Inline__InlineContainer-sc-1ppy24s-0") |>
    rvest::html_text() |>
    stringr::str_subset("price") |> 
    stringr::str_remove_all("Indicative price: ")

  card_property_details <-
    combined_xml_nodes |>
    rvest::html_elements("ul.residential-card__primary") |>
    rvest::html_attr("aria-label")

  card_url <-
    stringr::str_c(
      "https://www.realestate.com.au",
      combined_xml_nodes |>
        rvest::html_element("a") |>
        rvest::html_attr("href")
    )

  if (rlang::is_empty(card_indicative_price)) {
    tibble::tibble(
      Address = card_description,
      `Price Range` = card_title,
      Details = card_property_details,
      URL = card_url
    )
  } else {
    tibble::tibble(
      Address = card_title,
      `Price Range` = card_indicative_price,
      Details = card_property_details,
      URL = card_url
    )
  }
}
