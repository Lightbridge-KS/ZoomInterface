### Module: Time Unit & Round

library(shiny)

time_units_lookup <- list(
  # Label = Value
  "Minute" = "minute", 
  "Hour" = "hour",
  "Second" = "second",
  "Display Text (HMS)" = "period"
)

# Mod: UI -----------------------------------------------------------------


selectTimeUnit_UI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(4,
             selectInput(ns("unit"), "Choose units of time interval:",
                         choices = time_units_lookup, width = "250px")
             ),
      column(4,
             uiOutput(ns("round_disp"))
             )
    ),
    
    # Ref: https://stackoverflow.com/questions/36709441/how-to-display-widgets-inline-in-shiny
    
    # ## Block 1
    # div(
    #   style = "display: inline-block;vertical-align:top; width: 200px;",
    #   selectInput(ns("unit"), "Choose units of time interval:",
    #             choices = time_units_lookup, width = "200px")
    # ),
    # ## Width Between Block 1 & 2
    # div(style="display: inline-block;vertical-align:top; width: 25px;",HTML("<br>")),
    # 
    # ## Block 2
    # div(
    #   style = "display: inline-block;vertical-align:top; width: 150px;",
    #   uiOutput(ns("round_disp"))
    #   ),
    
    #verbatimTextOutput(ns("raw"))
  )
}

# Mod: Server -----------------------------------------------------------------

selectTimeUnit_Server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      #time_unit <- reactive({ input$unit })
      
      ### Render How to Round Digits
      output$round_disp <- renderUI({
        
        digits_default <- switch (input$unit,
          "minute" = { 1 },
          "hour" = { 2 },
          "second" = { 0 }
        )
        
        if (input$unit %in% c("minute", "hour", "second")) {
          
          numericInput(session$ns("round_digits"), "Significant Digits:", 
                       value = digits_default, min = 0, step = 1, width = "150px"
                       )
        }
        
      })
      
      output$raw <- renderPrint({ 
        list(
          time_unit = input$unit,
          round_digits = input$round_digits
          )
        
        })
      
      out <- reactive({
        list(
          time_unit = input$unit,
          round_digits = input$round_digits
        )
      })
      
      return(out)
  
    }
  )
}


