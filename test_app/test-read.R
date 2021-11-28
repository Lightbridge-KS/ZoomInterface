

library(shiny)

ui <- fluidPage(
  
 # fileInput("file", NULL, accept = c(".csv")),
  
  
  read_participants_UI("file_pp"),
  DT::DTOutput("table"),
  
  verbatimTextOutput("raw")
)

server <- function(input, output, session) {
  
  # data <- reactive({
  #   req(input$file) # Require - code wait until file uploaded
  #   zoomclass::read_participants(input$file$datapath)
  #   
  # })
  
  pp_raw <- read_participants_Server("file_pp")
  
  output$table <- DT::renderDT(pp_raw())
  
  output$raw <- renderPrint({
    #data()
    list(class = class(pp_raw()),
         content = pp_raw()
         )
  })
}

shinyApp(ui, server)