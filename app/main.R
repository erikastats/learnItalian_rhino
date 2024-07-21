box::use(
  shiny[bootstrapPage, div, moduleServer, NS, renderUI, tags, uiOutput,
        reactiveValues],
  bslib[page_navbar, nav_panel],
  tibble[tibble],
  lubridate[ymd_hms]
)

box::use(
  app/view/register_panel,
  app/logic/importing_data[italian_table]
)



#' @export
ui <- function(id) {
  ns <- NS(id)
  page_navbar(
    title = "Learning Italian helper",
    nav_panel(title = "Register",
              register_panel$ui(ns("register"))),
    nav_panel(title = "Cards"),
    nav_panel(title = "Data")
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {

    #reactive values
    r <- reactiveValues({ phrases_data = italian_table })

    #modules
    register_panel$server("register", r)


  })
}
