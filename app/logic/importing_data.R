# app/logic/importing_data.R

box::use(
  tibble[tibble],
  lubridate[ymd_hms])

# Define the directory and file name
directory <- "app/data/"
file_name <- "italian_table.rds"
file_path <- file.path(directory, file_name)


if (file.exists(file_path)) {
  it_table <- readRDS("app/data/italian_table.rds")
} else {
  it_table <- tibble(
    phrase = character(),
    date_created = ymd_hms(character()),
    last_usage = ymd_hms(character())
    )
}

#' @export
italian_table <- it_table

#' @export
total_phrases <- italian_table |> nrow()
