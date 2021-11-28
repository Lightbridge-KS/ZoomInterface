### Read xlsx or csv file
library(shiny)

# Fun: Read CSV File ---------------------------------------------------

read_participants_shiny <- function(file_name, file_path) {
  
  ext <- tools::file_ext(file_name)
  switch(ext,
         csv = zoomclass::read_participants(file_path),
         validate("Invalid file; Please upload Zoom participants as .csv file")
  )
  
}



# UI - read Zoom participants ---------------------------------------------------------------

read_participants_UI <- function(id, 
                    width = NULL,
                    buttonLabel = "Upload file", 
                    placeholder = "choose file .csv"
) {
  ns <- NS(id)
  tagList(
    shinyFeedback::useShinyFeedback(),
    fileInput(ns("file"), NULL, accept = c(".csv"), 
              buttonLabel = buttonLabel,
              placeholder = placeholder, width = width)
    
  )
}


# Server - read Zoom participants -----------------------------------------------------------

#' Read Zoom participants
#'
#' @param id Shiny id
#' @param warning Logical: Show shinyFeedback::feedbackWarning or not
#' @param warning_react Reactive value: If TRUE = show warning
#' @param warning_text Character: To display warning message
#'
#' @return A list
#' $data = Data Frame with class `zoom_participants`
#' $file_name = file name removed extension
#' 
read_participants_Server <- function(id, 
                        warning = F,
                        warning_react = NULL, # Reactive value To Warn: if TRUE = show warning
                        warning_text = "Incorrect file specification"
                        ) {
  moduleServer(
    id,
    function(input, output, session) {
      
      # Upload file  ---------------------------------------------------------------
      
      data <- reactive({
        
        req(input$file) # Require - code wait until file uploaded
        
        read_participants_shiny(file_name = input$file$name, file_path = input$file$datapath)
        
      })
      
      observeEvent(input$file, {
        
        if(warning){
          show_warning <- isTruthy(warning_react())
          shinyFeedback::feedbackWarning("file", show_warning, text = warning_text)
        }
        
      })
      
      
      # Return: list containing input data,  file name ---------------------------
      
      out <- reactive({

        file_name <- stringr::str_remove(input$file$name, "\\.[^\\.]+$") #remove .xxx (content after last dot)

        list(data = data(),
             file_name = file_name)
      })
      
      return(out)
      
      
    }
  )
}
