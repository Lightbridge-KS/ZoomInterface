library(shiny)

# Mod: lateTimeInput UI -----------------------------------------------------------------
lateTimeInput_UI <- function(id) {
  ns <- NS(id)
  tagList(
    checkboxInput(ns("check"), "Add late time ?", value = FALSE),
    uiOutput(ns("late_cutoff_disp")),
    #verbatimTextOutput(ns("raw"))
  )
}

# Mod: lateTimeInput Server -----------------------------------------------------------------
lateTimeInput_Server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      output$late_cutoff_disp <- renderUI({
        
        if(input$check){
          
          lateTimeBlock <- list(
            timeInput_UI(session$ns("late_cutoff"),
              label = tags$b("Late Time Cutoff = "),
              inline_label = TRUE
            ),
            helpText(
              "Student who first joined class later than this time cutoff
                   will have late time period displayed in the ", tags$code("Late_Time"),
              " column of the output."
            )
          )
          
          lateTimeBlock
        }
        
      })
      
      late_time <- timeInput_Server("late_cutoff")
      
      #output$raw <- renderPrint({ late_time() })
      
      return(late_time)
      
  
    }
  )
}
