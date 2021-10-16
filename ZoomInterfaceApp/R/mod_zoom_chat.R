### Read Zoom Chat .txt to DataFrame

library(shiny)

# UI ----------------------------------------------------------------------


zoom_chat_UI <- function(id) {
  ns <- NS(id)

    tabPanel("Zoom Chat Converter",
             h3("About"),
             tags$blockquote(
               "Convert program Zoom's chat file from Text to Excel"
             ),
             br(),
             fluidRow(
               column(6,
                      helpText("Step 1: Upload Zoom's Chat file as ", tags$code(".txt")),
                      br(),
                      fileInput(
                        ns("file"),
                        NULL,
                        accept = c(".txt"),
                        buttonLabel = "Upload file",
                        placeholder = "choose Zoom's chat .txt"
                      )
                      ),
               column(6,
                      helpText("Step 2: Download result as ", tags$code(".xlsx")),
                      br(),
                      downloadButton(ns("download"), "Download Excel")
                      )
             ),
             
            
             
             

             hr(),
             ### Table
             h3("Preview"),
             DT::DTOutput(ns("table")),
             
             ### Word Cloud
             hr(),
             h3("Word Cloud"),
             br(),
             plotOutput(ns("plot")),
             download_plot_UI(ns("download_plot"), label = "Download Wordcloud"),
             hr()
             
             #verbatimTextOutput(ns("raw"))
             
    )
    
}


# Server ------------------------------------------------------------------


zoom_chat_Server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      ### Read
      chat_df <- reactive({
        
        req(input$file)
        readzoom::read_zoom_chat(input$file$datapath)
        #read_zoom_chat(input$file$datapath)
        
      })
      
      ### Get File Name (removed extension)
      file_name <- reactive({
        
        stringr::str_remove(input$file$name,"\\.[^\\.]+$") #remove .xxx (content after last dot)
      
        })
      
      ### Show Table
      output$table <- DT::renderDT({
        
        chat_df()
        
      },
      options = list(lengthMenu = c(5,10,20,50), pageLength = 5 ),
      selection = 'none')
      
      ### Count Chat Contents
      word_df <- reactive({
        
        count_zoom_chat_contents(chat_df())
        
      })
      
      wordcloud <- reactive({
        
        set.seed(123)
        plot_wordcloud(word_df())
        
      })
      
      ### Show Plot
      
      output$plot <- renderPlot({
        
        wordcloud()
        
      }, res = 96)
      
      ### Download Plot
      
      download_plot_Server("download_plot", wordcloud, filename = "wordcloud-Zoom-Chat.jpg")
      
      
      ### Download Excel
      output$download <- downloadHandler(
        
        filename = function() {
          paste0(file_name(), ".xlsx") 
        },
        content = function(file) {
          
          write_custom.xlsx(list(Chat = chat_df()), file)
        }
      )
      
      # output$raw <- renderPrint({
      #   file_name()
      # })
  
  
    }
  )
}
