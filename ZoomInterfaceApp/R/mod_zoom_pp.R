### Module Read Zoom Participants

library(shiny)
library(dplyr)

# Mod UI: Zoom Participants -----------------------------------------------


zoom_participants_UI <- function(id) {
  ns <- NS(id)
  tabPanel("Zoom Class Report",
    
    fluidRow(
      column(9, 
             h2("Zoom Class Report"),
             tags$blockquote(
               "Analyse participants time information for classroom in program Zoom"
             ),
             ),
      column(3,
             ### Download
             download_xlsx_UI(ns("download"), "Download Excel")
             )
    ),
    
    helpText("1) ", "Upload Zoom's participants report file as ", tags$code(".csv")),
    
    
    br(),
    read_participants_UI(ns("file_pp")),
    
    ### Start & End time; Late Time; Time Unit
    uiOutput(ns("time_disp")),
    
    hr(),
    
    selectTimeUnit_UI(ns("time_unit_digits")),
    
    hr(),
    
    helpText("3) (Optional)", "Upload ID file that has column \"Name\" for student's names and \"ID\" for student's id numbers."),
    br(),
    fileInput(ns("file_id"), NULL, accept = c(".csv", ".xls",".xlsx"),buttonLabel = "Upload ID",
              placeholder = "choose file .csv or .xlsx"),
    select_id_cols_UI(ns("choose_cols")),
    
    
    ### Table
    h3("Students Summary"),
    DT::DTOutput(ns("table_studentID")),
    
    hr(),
    
    h3("Missing Names"),
    DT::DTOutput(ns("table_miss")),
    
    hr(),
    
    h3("Individual Sessions"),
    DT::DTOutput(ns("table_session")),
    
    verbatimTextOutput(ns("raw"))
    
  )
}

# Mod Server: Zoom Participants -----------------------------------------------


zoom_participants_Server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      

      # Read In -----------------------------------------------------------------


      data_input <- read_participants_Server("file_pp")
      
      data_cleaned <- reactive({ data_input()$data })
      file_name <- reactive({ data_input()$file_name })
      
      # Time --------------------------------------------------------------------

      output$time_disp <- renderUI({
        
        req(data_input())
        
        timeInputBlock <- list(
          
          hr(),
          helpText("2) ", "Choose time of class started & ended:"),
          br(),
          timeInput_UI(session$ns("time_start"), label = tags$b("Class Start Time = "), 
                       inline_label = TRUE),
          br(),
          timeInput_UI(session$ns("time_end"), label = tags$b("Class End Time = "),
                       inline_label = TRUE),
          br(),
          lateTimeInput_UI(session$ns("late_time"))
          
          
        )
        
        timeInputBlock 
        
      })
      
      ## Start & End Time
      start_time <- timeInput_Server("time_start")
      end_time <- timeInput_Server("time_end")
      ## Late Time
      late_time <- lateTimeInput_Server("late_time")
      
      # output$validate_time <- renderText({
      #   
      #   req(data_input())
      #   is_valid <- c(is.character(start_time()) && is.character(end_time()))
      # 
      #   if(!is_valid){
      #     HTML("<p style='color:#b30000;'>",
      #          "<b>Class Start</b>", "and", "<b>Class End</b>", "is required.",
      #          "</p>")
      #   }
      # })
      
      
      ## Units & Digits
      time_unit_digits <- selectTimeUnit_Server("time_unit_digits")
      
      time_unit <- reactive({ time_unit_digits()$time_unit })
      round_digits <- reactive({ time_unit_digits()$round_digits })
      
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
      
      # Class: Student ID -----------------------------------------------------------------
      
      data_studentsID <- reactive({
        
        req(start_time(), end_time())
        zoomclass::class_studentsID(data_cleaned(),
                                    id_regex = "[:digit:]{7}",
                                    collapse = "\n",
                                    class_start = start_time(),
                                    class_end = end_time(),
                                    late_cutoff = late_time(),
                                    period_to = time_unit(),
                                    round_digits = round_digits()
                                    ) %>% 
          dplyr::select(-Duration_Minutes) # Remove Zoom Artifact
      })
      
      # "Class Student ID" join with "ID file" --------------------------------------------------------------------
      
      data_studentsID_joined <- reactive({
        
        # Is ID file is ready (uploaded & valid)
        is_id_ready <- c( isTruthy(input$file_id) && is_valid_id() )
        
        # ID is not ready yet
        if( !is_id_ready ){
          
          data_studentsID()
          
          # ID is ready
        }else if( is_id_ready ){
          
          join_id(ids = id_df_selected(), df = data_studentsID())
          
        }
        
        
      })
      
      # Missing Names -----------------------------------------------------------
      
      
      data_studentsID_joined_missing <- reactive({
        
        data_studentsID_joined() %>% 
          dplyr::filter(if_any(starts_with("Name"), is.na))
      })

      # Session -----------------------------------------------------------------

      data_session <- reactive({
        
        req(start_time(), end_time())
        zoomclass::class_session(data_cleaned(),
                                 class_start = start_time(),
                                 class_end = end_time(),
                                 arrange_by = "Join_Time",
                                 arrange_group = "Name-Email",
                                 period_to = time_unit(),
                                 round_digits = round_digits()) %>% 
          dplyr::select(-Duration_Minutes) # Remove Zoom Artifact
      })
      


      
      # Table Output -----------------------------------------------------------------
      
      ### Table Student ID
      output$table_studentID <- DT::renderDT({
        
        if(time_unit() == "period"){
          ## Change to Chactacter so that DT can show it
          data_studentsID_joined() %>% 
            dplyr::mutate(across(where(lubridate::is.period), as.character))
          
        }else{
          
          data_studentsID_joined()
          
        }
        
      }, options = list(lengthMenu = c(5,10,20,50), pageLength = 5 ))
      
      ### Missing Names
      output$table_miss <- DT::renderDT({
        
        if(time_unit() == "period"){
          ## Change to Chactacter so that DT can show it
          data_studentsID_joined_missing() %>% 
            dplyr::mutate(across(where(lubridate::is.period), as.character))
          
        }else{
          
          data_studentsID_joined_missing()
          
        }

        }, options = list(lengthMenu = c(5,10,20,50), pageLength = 5 ))
        
      
      ### Table Session
      output$table_session <- DT::renderDT({
        
        if(time_unit() == "period"){
          ## Change to Chactacter so that DT can show it
          data_session() %>% 
            dplyr::mutate(across(where(lubridate::is.period), as.character))
          
        }else{
          
          data_session()
          
        }
        
      }, options = list(lengthMenu = c(5,10,20,50), pageLength = 5 ))
      

      # Download ----------------------------------------------------------------
      
      ## Must Construct File Name First
      file_name_download <- reactive({ paste0("ZoomClass_", file_name(), ".xlsx")})

      download_xlsx_Server("download",
                           list("Student Summary" = data_studentsID_joined(),
                                "Missing Names" = data_studentsID_joined_missing(),
                                "Individual Session" = data_session()),
                           filename_react = file_name_download # Pass w/o ()
                           )
      

      # Raw ---------------------------------------------------------------------

      # output$raw <- renderPrint({
      # 
      #   list(
      #     # file_nm = file_name(),
      #     # start = start_time(),
      #     # end = end_time()
      #     # data_studentsID_joined()
      #     # data_cleaned = data_cleaned(),
      #     # data_session = data_session()
      #     )
      #   
      # })
  
  
    }
  )
}
