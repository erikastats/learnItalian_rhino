# app/logic/random_cards.R

box::use( dplyr[pull, slice_sample, row_number,
                mutate, select],
          tibble[tibble])

#' Select random italian phrases to display in cards
#'
#' @param data Data frame with italian phrases
#' @param n_cards Number of cards that should be selected (50, 100 or 'All')
#' @return Vector with phrases chosen randomly
#' @export

select_random_cards <- function(data, n_cards ){

  if (n_cards != "All"){
    ncards = n_cards |> as.integer()
  } else (
    ncards = nrow(data)
  )
  df <- data |>
    slice_sample(n = ncards) |>
    mutate(id = row_number())

  df |>
    select(id, phrase)
}

#' @export
card_picker_df <- tibble(
  card_picker = c("Short - 25",
                  "Median - 50", "Long - 100",
                  "Ideal - All"),
  c_number = c("25", "50", "100", "All")
                          )

