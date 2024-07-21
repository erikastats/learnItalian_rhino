# app/view/register_panel.R

box::use(
  shiny[moduleServer, NS, tagList,
         icon, observeEvent,
        renderText, textOutput , textInput,
        img, h3, reactive, renderPrint, uiOutput, column],
  bslib[card, card_header, card_body, card_footer],
  shinyWidgets[show_alert, actionBttn],
  lubridate[now, ymd_hms],
  tibble[tibble],
  stringr[str_to_sentence],
  dplyr[bind_rows],
  waiter[useWaiter, waiter_show_on_load, waiter_hide, transparent]
)

box::use(
  app/view/table_data,
  app/view/save_table_module
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
    card_body(column(width = 6,
                     textInput(ns("text"),
                               label = "",
                               placeholder = "Add italian phrase")),
              column(width = 6,
                     textOutput(ns("text_out"))),
      table_data$ui(ns("table"))
      ),
    card_footer( actionBttn(ns("go"),
                              label = "Add phrase",
                              icon = icon("plus")),
                 save_table_module$ui(ns("save"), Label = "Save table")

                 )
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


    # reactive
    new_row <- reactive({
      tibble(
      phrase = c(input$text |> str_to_sentence()),
      date_created = c(now()),
      last_usage = c(NA) )
    })

    # Observe
    observeEvent(input$go, {
      show_alert(
        title = "Phrase added with success!",
        text = input$text,
        type = "success"
      )

      # Update the reactive data frame in the main app


      r$phrases_data <- bind_rows(r$phrases_data, new_row())
    })


    # module
    table_data$server("table", reactive({ r$phrases_data }))
    save_table_module$server("save",
                             reactive({ r$phrases_data }),
                             "app/data/product_table.rds")


  })
}
