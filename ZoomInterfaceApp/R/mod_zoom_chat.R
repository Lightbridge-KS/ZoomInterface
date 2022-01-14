### Read Zoom Chat .txt to DataFrame

library(shiny)
library(ggplot2)


# UI ----------------------------------------------------------------------


zoom_chat_UI <- function(id) {
  ns <- NS(id)

    tabPanel("Zoom Chat Explore",
             h3("Zoom Chat Explore"),
             tags$blockquote(
               "Convert program Zoom's chat file from Text to Excel, count messages per participants, and display Word clouds"
             ),
             br(),
             fluidRow(
               column(6,
                      helpText("1) Upload Zoom's Chat file as ", tags$code(".txt")),
                      br(),
                      fileInput(
                        ns("file"),
                        NULL,
                        accept = c(".txt"),
                        buttonLabel = "Upload file",
                        placeholder = "choose Zoom's chat .txt"
                      ),
                      
                      helpText("2) (Optional)", "Upload ID file that has column \"Name\" for student's names and \"ID\" for student's id numbers."),
                      br(),
                      fileInput(ns("file_id"), NULL, accept = c(".csv", ".xls",".xlsx"),buttonLabel = "Upload ID",
                                placeholder = "choose file .csv or .xlsx"),
                      select_id_cols_UI(ns("choose_cols")),
                      
                      ),
               column(6,
                      helpText("Download result as ", tags$code(".xlsx")),
                      br(),
                      downloadButton(ns("download"), "Download Excel")
                      )
             ),
             
            
        

             hr(),
             
             ### Table: Raw
             h3("Raw Chat"),
             br(),
             h5("Output Columns:"),
             tags$ul(
               tags$li(tags$b("Time: "), "Time Stamp from each messages"),
               tags$li(tags$b("Name: "), "Name of participants"),
               tags$li(tags$b("Target: "), "Target that each participants messages to"),
               tags$li(tags$b("Content: "), "Messages of each participants as entered in the chat box"),
             ),
             DT::DTOutput(ns("table")),
             
             hr(),
             ## Table: Count 
             h3("Count Chat"),
             br(),
             h5("Output Columns:"),
             tags$ul(
               tags$li(tags$b("ID: "), "7 consecutive digits extracted from column: ", tags$code("Name")),
               tags$li(tags$b("Name*: "), "Name of participants"),
               tags$li(tags$b("Message_Count: "), "Counts of how many times each participants replies"),
               tags$li(tags$b("Content: "), "Messages of that participants entered in the chat box, each seperated by ", tags$code(" ~ ")),
              ),
             
             DT::DTOutput(ns("table_counted")),
             
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
      

# Zoom Chat ---------------------------------------------------------------

      
      ### Read Raw
      chat_df <- reactive({
        
        req(input$file)
        zoomclass::read_zoom_chat(input$file$datapath)
        #read_zoom_chat(input$file$datapath)
        
      })
      
      ### Get File Name (removed extension)
      file_name <- reactive({
        
        stringr::str_remove(input$file$name,"\\.[^\\.]+$") #remove .xxx (content after last dot)
      
        })
      
      ### Chat Count
      chat_counted <- reactive({
        zoomclass::zoom_chat_count(chat_df(),
                                   collapse = " ~ ",
                                   extract_id = TRUE,
                                   id_regex = "[:digit:]{7}")
      })
      
# Read ID file ------------------------------------------------------------
      
      id_df <- reactive({ 
        
        req(input$file_id) # Require - code wait until file uploaded
        read_single(file_name = input$file_id$name,
                    file_path = input$file_id$datapath) 
        
      })
      
      
      # Validate ID file ------------------------------------------------------------
      
      is_valid_id <- reactive({
        
        id_regex <- c("Name", "ID")
        all( is_regex_in_names(id_df(), regex = id_regex) )
        
      })
      
      observeEvent(input$file_id,
                   shinyFeedback::feedbackWarning(
                     "file_id",
                     !is_valid_id(),
                     "ID file must have column 'Name' and 'ID'"
                   )
      )
      
      # Select ID column --------------------------------------------------------------------
      
      id_df_selected <- select_id_cols_Server("choose_cols", id_df)
      

# Join ID file ------------------------------------------------------------

      chat_counted_joined <- reactive({
        
        # Is ID file is ready (uploaded & valid)
        is_id_ready <- c( isTruthy(input$file_id) && is_valid_id() )
        
        # ID is not ready yet
        if( !is_id_ready ){
          
          chat_counted()
          
          # ID is ready
        }else if( is_id_ready ){
          
          join_id(ids = id_df_selected(), df = chat_counted())
          
        }
        
        
      })
      
      

      # Show Table --------------------------------------------------------------

      
      ### Show Table: Raw
      output$table <- DT::renderDT({
        
        chat_df()
        
      },
      options = list(lengthMenu = c(5,10,20,50), pageLength = 5 ),
      selection = 'none')
      
      ### Show Table: Count Messages
      output$table_counted <- DT::renderDT({
        
        chat_counted_joined()
        
      }, options = list(lengthMenu = c(5,10,20,50), pageLength = 5 ),
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
      
      download_plot_Server("download_plot", wordcloud, filename = "wordcloud-Zoom-Chat.png")
      
      
      ### Download Excel
      output$download <- downloadHandler(
        
        filename = function() {
          paste0(file_name(), ".xlsx") 
        },
        content = function(file) {
          
          write_custom.xlsx(list(
            Chat_Raw = chat_df(),
            Chat_Count = chat_counted_joined()
            ), file)
        }
      )
      
      # output$raw <- renderPrint({
      #   file_name()
      # })
  
  
    }
  )
}
