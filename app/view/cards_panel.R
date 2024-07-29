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
                                card_picker_df],
         app/view/random_cards_module,
         app/logic/importing_data[italian_table, total_phrases]
         )

# UI ----------------------------------------------------------------------


#' @export
ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(width = 6, card(
        full_screen = TRUE,
        value_box(title = "Total cards",
                  value = total_phrases,
                  icon = icon("rug") )
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
    )

  )
}


# SERVER ------------------------------------------------------------------

#' @export
server <- function(id) {
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
      select_random_cards(italian_table, card_p() )
    }) |>
      bindEvent(input$generate_cards)


  })
}

# create a module to generate random cards
# sliderInput("card_qt",
#             label = h3("Choose cards quantity"),
#             min = 0,
#             max = 100, value = 50)
