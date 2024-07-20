# app/view/register_panel.R

box::use(
  shiny[moduleServer, NS, tagList,
        actionButton, icon, observeEvent,
        renderText, textOutput , textInput,
        img, h3, reactive, renderPrint, uiOutput],
  bslib[card, card_header, card_body, card_footer],
  shinyWidgets[show_alert],
  lubridate[now, ymd_hms],
  tibble[tibble],
  stringr[str_to_sentence],
  dplyr[bind_rows],
  waiter[useWaiter, waiter_show_on_load, waiter_hide, transparent]
)

box::use(
  app/view/table_data
)


# UI ----------------------------------------------------------------------


#' @export
ui <- function(id){
  ns <- NS(id)
  tagList(
    useWaiter(),
    waiter_show_on_load(
      html = tagList(
        img(src = "https://media.giphy.com/media/l1J9GDDWbN06mMInu/giphy.gif"),
        h3("Loading, please wait...")
      ),
      color = transparent(0.3)
    ),
    card(
    full_screen = TRUE,
    card_header( "Insert an italian phrase here" ),
    card_body(
      textInput(ns("text"),
                label = "",
                placeholder = "Add italian phrase"),
      textOutput(ns("text_out")),
      table_data$ui(ns("table")),
      uiOutput(ns("pure_data"))
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
    Sys.sleep(2)
    # waiter
    waiter_hide()

    # output
    output$text_out <- renderText({
      input$text
    })

    output$pure_data <- renderPrint({
      r$phrases_data
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
        date_created = now(),
        last_usage = ymd_hms(character())
      )

      r$phrases_data <- bind_rows(r$phrases_data, new_row)
    })


    # module
    table_data$server("table", reactive( {r$phrases_data} ))



  })
}
