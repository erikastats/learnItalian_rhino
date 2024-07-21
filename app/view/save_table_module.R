# app/view/save_table_module.R

box::use(
  shiny[moduleServer, NS, tagList, textInput, icon, observeEvent],
  shinyWidgets[show_alert, actionBttn],
)


# UI ----------------------------------------------------------------------


#' @export
ui <- function(id, Label){
  ns <- NS(id)
  tagList(
    actionBttn(ns("save"),
               label = Label,
               icon = icon("floppy-disk")
    )
  )
}


# SERVER ------------------------------------------------------------------

#' @export
server <- function(id, data, path_data) {
  moduleServer(id, function(input, output, session){

    observeEvent(input$save, {
      # "./Data/product_table.rds"
      data() |>
        saveRDS(path_data)

      show_alert(
        title = "Table saved!",
        text = paste0("Your table was saved and updated successfully!",
        type = "success"
      ))

    })

  })
}
