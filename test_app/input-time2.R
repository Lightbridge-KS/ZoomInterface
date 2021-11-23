library(shiny)

ui <- fluidPage(
  
  timeInput("time_html1", id_html = "ui_time1", label = "Start Time:"),
  timeInput("time_html2", id_html = "ui_time2", label = "End Time:"),
  
  verbatimTextOutput("raw")
)

server <- function(input, output, session) {
  
  output$raw <- renderPrint({
    list(input = c(input$time_html1, input$time_html2), 
         class = c(class(input$time_html1), class(input$time_html2))
    )
  })
}

shinyApp(ui, server)