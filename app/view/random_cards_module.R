# app/view/cards_panel.R

box::use(
  shiny[moduleServer, NS, tagList,
        textOutput, renderText, bindEvent,
        h3, reactive],
  shinyWidgets[ actionBttn, progressBar, updateProgressBar],
  dplyr[pull, filter]
)



# UI ----------------------------------------------------------------------


#' @export
ui <- function(id, card_number){
  ns <- NS(id)
  tagList(
    progressBar(id = ns("progress_card"),
                value = 1,
                total = card_number,
                status = "info",
                display_pct = TRUE,
                striped = TRUE,
                title = "Quantity of cards to study"),
    h3(textOutput(ns("text_card"))),
    actionBttn(ns("next_card"), label = "Next card!")

  )
}


# SERVER ------------------------------------------------------------------

#' @export
server <- function(id, data) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    # reactive
    df_phrases <- reactive({
      data |>
        filter(row_number() == (input$next_card + 1))
    })
    # output
    output$text_card <- renderText({
      df_phrases() |> pull(phrase)
    }) |>
      bindEvent(input$next_card)

    observeEvent(input$next_card, {
      updateProgressBar(session = session,
                        id = ns("progress_card"),
                        value = input$next_card + 1)

    })

  })
}

# receive some data with these columns phrase,  date_created, last_usage
# - Display a progress bar with the total phrases and number of phrases already displayed
# - Display each phrase in sequence
# - everytime I click on the action button "next", the phrase changes and de progress bar increse in one
# - At the same time, saves the time the action button was clicked
# - return a data with the phrase, and the time the "next" button was clicked
# - At the end of all phrases, when clicking the "next" button, show the phrase: "you completed your practice. Good Job!" and the "next" button label as "restart". If the "restart" button is clicked, the "next" button should be reiniciated and return to show the phrases in sequence.
# at all time it should be another button to save the progress at any moment
# - the next button should also update the column last_usage for the last phrase displayed
