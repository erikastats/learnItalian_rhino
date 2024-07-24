# app/view/cards_panel.R

box::use(
  shiny[moduleServer, NS, tagList,
         uiOutput, renderUI, icon,
        fluidRow, column, bindEvent,
        h3, reactive],
  bslib[card, card_header, card_body,
        card_footer, value_box],
  shinyWidgets[radioGroupButtons, actionBttn],
  dplyr[summarise, pull, n, filter]
)

box::use(app/logic/random_cards[select_random_cards,
                                card_picker_df])

# UI ----------------------------------------------------------------------


#' @export
ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(width = 6, card(
        full_screen = TRUE,
        card_body( uiOutput(ns("value_box")) )
      )),
      column(width = 6,
             card(
               full_screen = TRUE,
               card_body(
                 radioGroupButtons(
                   inputId = ns("card_picker"),
                   label = "Select your level",
                   choices = c("Short - 25",
                               "Median - 50", "Long - 100",
                               "Ideal - All"),
                   justified = TRUE,
                   checkIcon = list(
                     yes = icon("ok",
                                lib = "glyphicon"))
                 )),
               card_footer( actionBttn(ns("generate_cards"),
                                       label = "Generate cards") )
             )
             )
    ),
    uiOutput(ns("card_phrase"))

  )
}


# SERVER ------------------------------------------------------------------

#' @export
server <- function(id, data) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    # reactive
    card_p <- reactive({
      card_picker_df |>
        filter(input$card_picker == card_picker) |>
        pull(c_number)
    }) |>
      bindEvent(input$generate_cards)

    data_cards <- reactive({
      select_random_cards(data(), card_p() )
    }) |>
      bindEvent(input$generate_cards)

    # output
    output$value_box <- renderUI({
      value_cards = data() |>
        summarise( unique_phrase = n()) |>
        pull(unique_phrase)

      value_box(title = "Total cards",
                value = value_cards, icon = icon("rug") )
    })


    output$card_phrase <- renderUI({

      card(
        full_screen = TRUE,
        card_header(progressBar(id = ns("progress_cards"),
                                value = 1,
                                total = card_p()
                                )),
        card_body(
            h3()
        ),
        card_footer( actionBttn(ns("next_card"),
                                label = "Next card") )
      )

    })

  })
}

# create a module to generate random cards
# sliderInput("card_qt",
#             label = h3("Choose cards quantity"),
#             min = 0,
#             max = 100, value = 50)
