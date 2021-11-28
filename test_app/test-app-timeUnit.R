library(shiny)

ui <- fluidPage(
  selectTimeUnit_UI("unit"),
  verbatimTextOutput("raw")
)

server <- function(input, output, session) {
  
  time_unit <- selectTimeUnit_Server("unit")
  
  output$raw <-  renderPrint({ time_unit() })
  
}

shinyApp(ui, server)