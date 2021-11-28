library(shiny)

ui <- fluidPage(
  lateTimeInput_UI("late")
)

server <- function(input, output, session) {
  
  lateTimeInput_Server("late")
  
}

shinyApp(ui, server)