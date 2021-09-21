### Read Zoom Chat .txt to DataFrame

library(shiny)

# UI ----------------------------------------------------------------------


zoom_chat_UI <- function(id) {
  ns <- NS(id)

    tabPanel("Read Zoom Chat",
             
             fileInput(
               ns("file"),
               NULL,
               accept = c(".txt"),
               buttonLabel = "Upload file",
               placeholder = "choose Zoom's chat .txt"
             ),
             
             DT::DTOutput(ns("table")),
             
             verbatimTextOutput(ns("raw"))
             
    )
    
}


# Server ------------------------------------------------------------------


zoom_chat_Server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      chat_df <- reactive({
        
        req(input$file)
        read_zoom_chat(input$file$datapath)
        
      })
      
      output$table <- DT::renderDT({
        
        chat_df()
        
      },
      options = list(lengthMenu = c(5,10,20,50), pageLength = 5 ),
      selection = 'none')
      
      
      
      output$raw <- renderPrint({
        chat_df()
      })
  
  
    }
  )
}
