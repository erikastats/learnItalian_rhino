# app/view/table_data.R

box::use(
  shiny[moduleServer, NS, tagList, br, uiOutput, renderPrint],
  reactable[reactableOutput, renderReactable, reactable, colDef]
)


# UI ----------------------------------------------------------------------


#' @export
ui <- function(id){
  ns <- NS(id)
  tagList(
    br(),
    reactableOutput(ns("table_data"))
  )
}


# SERVER ------------------------------------------------------------------

#' @export
server <- function(id, data) {
  moduleServer(id, function(input, output, session){

    # output
    output$table_data <- renderReactable({
      data() |>
        reactable(
          searchable = TRUE,
          highlight = TRUE,
          paginationType = "simple",
          minRows = 10,
          defaultColDef = colDef(headerClass = "header", align = "left",
                                 minWidth = 100,
                                 headerStyle = list(fontWeight = "bold"),
                                 footerStyle = list(fontWeight = "bold")),
          columns = list(
            phrase = colDef( name = "Italian phrase"),
            date_created = colDef(name = "Created in"),
            last_usage = colDef(name = "Last date usage")
          )
        )
    })


  })
}
