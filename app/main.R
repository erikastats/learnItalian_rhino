box::use(
  shiny[bootstrapPage, div, moduleServer, NS, renderUI, tags, uiOutput],
  bslib[page_navbar, nav_panel]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  page_navbar(
    title = "Learning Italian helper",
    nav_panel(title = "Register"),
    nav_panel(title = "Cards"),
    nav_panel(title = "Data")
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {

  })
}
