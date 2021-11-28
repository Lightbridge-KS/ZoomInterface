library(shiny)

ui <- fluidPage(
  download_xlsx_UI("download"),
  textInput("text", "File Names:")
)

server <- function(input, output, session) {
  
  data <- reactive({ iris })
  
  text_react <- reactive({   paste0(input$text , ".xlsx") })
  
  download_xlsx_Server("download", 
                       list(dat = data()), 
                       "iris.xlsx",
                       text_react
                       )
  
}

shinyApp(ui, server)