### Module Input Time
library(shiny)

# Function: Time Input as HTML ------------------------------------------------------


timeInput <- function(id_shiny, 
                      id_html,
                      label = "Time:",
                      inline_label = TRUE
) {
  
  # Label ID
  labs_id <- glue::glue("<<id_html>>", .open = "<<", .close = ">>")
  
  # Time Input HTML
  input_time <- glue::glue(
    '<input id="<<id_html>>" type="time", value = ""><br>', 
    .open = "<<", .close = ">>"
    )
  
  if(!inline_label){
    ## Inline label?
    input_time <- paste0("<br>", input_time, "<br>")
  }
  
  # JavaScript
  js_script <- glue::glue(
    'document.getElementById("<<id_html>>").onchange = function() {
						var time = document.getElementById("<<id_html>>").value;
						Shiny.setInputValue("<<id_shiny>>", time);
					};', 
    .open = "<<", .close = ">>")
  
  out <- list(
    shiny::tags$label(label, `for` = labs_id),
    shiny::HTML(input_time),
    shiny::tags$script(HTML(js_script))
  )
  
  out
  
}


# Mod UI: Time Input ----------------------------------------------------------


timeInput_UI <- function(id,
                         label = "Time:",
                         inline_label = TRUE
                         ) {
  ns <- NS(id)
  tagList(

    timeInput(ns("time_hm"), id_html = ns("ui_time"), 
              label = label, 
              inline_label = inline_label),
    
    verbatimTextOutput(ns("raw"))
  )
}



# Mod Server: Time Input ----------------------------------------------------------

timeInput_Server <- function(id) {
  
  moduleServer(
    id,
    function(input, output, session) {
      
      
     time_chr <- reactive({ 
       input$time_hm 
      })
      
      # output$raw <- renderPrint({
      #   # list(input = time_chr(), 
      #   #      class = class(time_chr()))
      #   time_chr()
      #   
      # })
      
      return(time_chr)
  
    }
  )
}
