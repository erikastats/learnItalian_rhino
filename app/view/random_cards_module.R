# app/view/random_cards_module

box::use(
  shiny[moduleServer, NS, tagList,
        textOutput, renderText, bindEvent,
        h3, reactive, uiOutput, renderUI, reactiveVal,
        observeEvent],
  shinyWidgets[ actionBttn, progressBar, updateProgressBar],
  dplyr[pull, filter],
  lubridate[now]
)



# UI ----------------------------------------------------------------------


#' @export
ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("progress")),
    h3(textOutput(ns("text_card"))),
    actionBttn(ns("next_card"), label = "Next card!")

  )
}


# SERVER ------------------------------------------------------------------

#' @export
server <- function(id, data, card_number) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    # reactive
    current_index <- reactiveVal(1)
    df_phrases <- reactive({
      data |>
        filter(row_number() == current_index())
    })

    # output
    output$progress <- renderUI({
      progressBar(id = ns("progress_card"),
                  value = current_index(),
                  total = card_number(),
                  status = "info",
                  display_pct = TRUE,
                  striped = TRUE,
                  title = "Quantity of cards to study")
    })

    output$text_card <- renderText({
      if (current_index() <= card_number()) {
        df_phrases() |> pull(phrase)
      } else {
        "You completed your practice. Good Job!"
      }
    })

    # observe
    observeEvent(input$next_card, {
      if (current_index() <= card_number()) {
        updateProgressBar(session = session,
                          id = ns("progress_card"),
                          value = current_index())

        # Save the current time the button was clicked
        new_entry <- data.frame(
          phrase = isolate(df_phrases() |> pull(phrase)),
          time_clicked = now()
        )
        saved_times(bind_rows(saved_times(), new_entry))

        # Update last_usage for the current phrase
        data <- data |>
          mutate(last_usage = if_else(row_number() == current_index(), now(), last_usage))

        # Increment the index
        current_index(current_index() + 1)
      } else {
        # Restart logic
        current_index(1)
        updateProgressBar(session = session,
                          id = ns("progress_card"),
                          value = current_index(1))
      }

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
