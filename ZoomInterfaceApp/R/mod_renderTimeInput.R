library(shiny)


# Mod: renderTimeInput UI -----------------------------------------------------------------
renderTimeInput_UI <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("time_disp")),
    verbatimTextOutput(ns("raw"))
  )
}

# Mod: renderTimeInput Server -----------------------------------------------------------------
renderTimeInput_Server <- function(id, 
                                   render_lgl = NULL
                                   ) {
  moduleServer(
    id,
    function(input, output, session) {
      
      render <- reactive({ render_lgl })
      
      output$time_disp <- renderUI({
        
        timeInputBlock <- list(
          
          helpText("2) ", "Choose time of class started & ended:"),
          br(),
          timeInput_UI(session$ns("time_start"), label = tags$b("Class Start:"), 
                       inline_label = TRUE),
          br(),
          timeInput_UI(session$ns("time_end"), label = tags$b("Class End:"),
                       inline_label = TRUE),
          br()
          
          
        )

        if(render())  return( timeInputBlock )
        
      })
      
      output$raw <- renderPrint({ 
        list(render = render()) 
        })
  
  
    }
  )
}
