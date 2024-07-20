# app/view/register_panel.R

box::use(
  shiny[moduleServer, NS, tagList,
        actionButton, icon, observeEvent,
        renderText, textOutput , textInput],
  bslib[card, card_header, card_body, card_footer],
  shinyWidgets[show_alert],
  lubridate[now],
  tibble[tibble],
  stringr[str_to_sentence],
  dplyr[bind_rows]
)


# UI ----------------------------------------------------------------------


#' @export
ui <- function(id){
  ns <- NS(id)
  tagList(card(
    full_screen = TRUE,
    card_header( "Insert an italian phrase here" ),
    card_body(
      textInput(ns("text"),
                label = "",
                placeholder = "Add italian phrase"),
      textOutput(ns("text_out"))
      ),
    card_footer( actionButton(ns("go"),
                              label = "Add phrase",
                              icon = icon("plus")))
  ))
}


# SERVER ------------------------------------------------------------------

#' @export
server <- function(id, r) {
  moduleServer(id, function(input, output, session){

    # output
    output$text_out <- renderText({
      input$text
    })

    # Observe
    observeEvent(input$go, {
      show_alert(
        title = "Phrase added with success!",
        text = input$text,
        type = "success"
      )

      # Update the reactive data frame in the main app
      new_row <- tibble(
        phrase = input$text |> str_to_sentence(),
        date_created = now()
      )

      r$phrases_data <- bind_rows(r$phrases_data, new_row)
    })

  })
}
