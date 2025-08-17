create_listing_spreadsheet <- function(url_to_scrape, scrapfly_api_key) {
  
  listings_data <- scrape_real_estate_com(url_to_scrape, scrapfly_api_key)

  article_workbook <- openxlsx2::wb_workbook()
  
  add_table_style(article_workbook)
  
  add_title_table_to_sheet(article_workbook, "Listings", listings_data)
  
  temporary_path <-
    file.path(
      tempdir(),
      stringr::str_glue("Realestate.com Listings - {Sys.Date()}.xlsx")
    )
  
  article_workbook$save(file = temporary_path, overwrite = TRUE)
  
  return(temporary_path)
}

add_title_table_to_sheet <- function(workbook, sheet, data) {
  workbook$add_worksheet(sheet, grid_lines = FALSE)
  
  workbook$add_data_table(
    sheet = sheet,
    x = data,
    startCol = 2,
    startRow = 2,
    table_style = "cci_standard_table"
  )
  
  url_col_letter <- openxlsx2::int2col(2 + which(names(data) == "URL") - 1)
  dims_range <- paste0(url_col_letter, 3, ":", url_col_letter, nrow(data) + 2)
  
  workbook$add_hyperlink(
    sheet = sheet,
    dims = dims_range,
    is_external = TRUE
  )
  
  workbook$set_col_widths(
    sheet = sheet, cols = c(1, 6), widths = 1.44
  )
  
  workbook$set_row_heights(
    sheet = sheet, rows = 1, heights = 12
  )
  
  workbook$set_col_widths(
    sheet = sheet, cols = 2:5, widths = "auto"
  )
  
  workbook$set_col_widths(
    sheet = sheet, cols = 7:16384, hidden = TRUE
  )
  
  return(TRUE)
}

add_table_style <- function(workbook) {
  style_whole_table <-
    openxlsx2::create_dxfs_style(
      font_name = "Calibri",
      font_color = openxlsx2::wb_color("black"),
      border = TRUE,
      border_color = openxlsx2::wb_color("black"),
      border_style = "thin"
    )
  
  style_header_row <-
    openxlsx2::create_dxfs_style(
      font_name = "Calibri",
      font_color = openxlsx2::wb_color("white"),
      text_bold = TRUE,
      bg_fill = openxlsx2::wb_color("darkblue"),
      fg_color = openxlsx2::wb_color("red"),
      border = TRUE,
      border_color = openxlsx2::wb_color("black"),
      border_style = "thin"
    )
  
  style_first_row_stripe <-
    openxlsx2::create_dxfs_style(
      bg_fill = openxlsx2::wb_color("white")
    )
  
  style_second_row_stripe <-
    openxlsx2::create_dxfs_style(
      bg_fill = openxlsx2::wb_color("#F0F0F0")
    )
  
  workbook$add_style(style_whole_table)
  workbook$add_style(style_header_row)
  workbook$add_style(style_first_row_stripe)
  workbook$add_style(style_second_row_stripe)
  
  xml <-
    openxlsx2::create_tablestyle(
      name = "cci_standard_table",
      whole_table = workbook$styles_mgr$get_dxf_id("style_whole_table"),
      header_row = workbook$styles_mgr$get_dxf_id("style_header_row"),
      first_row_stripe = workbook$styles_mgr$get_dxf_id("style_first_row_stripe"),
      second_row_stripe = workbook$styles_mgr$get_dxf_id("style_second_row_stripe")
    )
  
  workbook$add_style(xml)
  
  return(TRUE)
}
