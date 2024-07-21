# app/view/cards_panel.R

box:use(
  shiny[moduleServer, NS, tagList, actionButton, textInput,
        sliderInput],
  bslib[card, card_header, card_body, card_footer]
)



# UI ----------------------------------------------------------------------


#' @export
ui <- function(id){
  ns <- NS(id)
  tagList(
    card(
      full_screen = TRUE,
      card_header(
        "This is the header"
      ),
      card_body(

      ),
      card_footer(
        "This is the footer"
      )
    )
  )
}


# SERVER ------------------------------------------------------------------

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session){


  })
}

# sliderInput("card_qt",
#             label = h3("Choose cards quantity"),
#             min = 0,
#             max = 100, value = 50)
