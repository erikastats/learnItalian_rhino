# app/logic/random_cards.R

box::use( dplyr[ slice_sample, row_number,
                mutate, select, filter],
          tibble[tibble])

card_picker_df <- tibble(
  card_picker = c("Short - 25",
                  "Median - 50", "Long - 100",
                  "Ideal - All"),
  c_number = c("25", "50", "100", "All")
)

#' Select random italian phrases to display in cards
#'
#' @param data Data frame with italian phrases
#' @param n_cards Number of cards that should be selected (50, 100 or 'All')
#' @return Vector with phrases chosen randomly
#' @export

select_random_cards <- function(data, n_cards ){

  cp_df = card_picker_df |>
    filter(card_picker == n_cards) |>
    mutate(c_number = c_number |> as.integer()) |>
    mutate(c_number = ifelse(is.na(c_number), nrow(data), c_number))

  ncards = ifelse(cp_df$c_number >= nrow(data),
                  nrow(data),
                  cp_df$c_number)

  df <- data |>
    slice_sample(n = ncards) |>
    mutate(id = row_number())

  df
}



