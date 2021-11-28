library(shiny)

ui <- fluidPage(
  timeInput_UI("time", label = "Time 1", inline_label = TRUE),
  timeInput_UI("time2", label = "Time 2"),
  verbatimTextOutput("raw")
)

server <- function(input, output, session) {
  tm1 <- timeInput_Server("time")
  tm2 <- timeInput_Server("time2")
  
  output$raw <- renderPrint({
    list(
      tm1(), tm2()
    )
  })
}

shinyApp(ui, server)