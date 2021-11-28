library(shiny)

ui <- fluidPage(
  renderTimeInput_UI("time"),
  checkboxInput("check", "Render?"),
  verbatimTextOutput("raw")
)

server <- function(input, output, session) {
  
  is.check <- reactive({input$check})
  
  renderTimeInput_Server("time", render_lgl = is.check())
  
  output$raw <- renderPrint({ input$check })
}

shinyApp(ui, server)