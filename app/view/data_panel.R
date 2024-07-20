# app/view/data_panel.R

box:use(
  shiny[moduleServer, NS, tagList, actionButton, textInput],
  bslib[card, card_header, card_body, card_footer]
)


# UI ----------------------------------------------------------------------


#' @export
ui <- function(id){
  ns <- NS(id)
  tagList()
}


# SERVER ------------------------------------------------------------------

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session){


  })
}
