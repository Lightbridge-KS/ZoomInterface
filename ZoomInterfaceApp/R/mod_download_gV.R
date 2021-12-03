### Download list of DF arranged in an verical grid layout in Excel

library(shiny)

# Function: Write Custom Excel -------------------------------------------------------------


write_gV.xlsx <- function(..., filename) {
  
  lbdoc::write.xlsx_gV(
    ...,
    file = filename,
    freezePane_args = list(firstActiveRow = c(7, 2, 2))
  )
  
}


# UI: Download botton -----------------------------------------------------


download_xlsx_gV_UI <- function(id, botton_labs = "Download") {
  ns <- NS(id)
  tagList(
    shiny::downloadButton(ns("download_xlsx"), botton_labs),
    #verbatimTextOutput(ns("raw"))
  )
}


# Server: write excel -----------------------------------------------------




#' Download Excel vertical Grid Server
#' 
#' When providing reactive file name to `filename_react`, DO NOT wrap parenthesis around it.
#' If you want to construct file name, it must be constricted to a single reactive object
#' before passing to this argument.
#'
#' @param id shiny ID
#' @param ... named list of reactive object to download (stacked vertically in each list)
#' @param filename (static) file name
#' @param filename_react (reactive) reactive file name. If provided, ignore `filename`
#'
#' @return Nothing
download_xlsx_gV_Server <- function(id,
                                    ...,
                                    filename = "report.xlsx", # file name in download wizard
                                    filename_react = reactiveVal(NULL)
                                 
) {
  moduleServer(
    id,
    function(input, output, session) {
      
      file_name <- reactive({
        # IF Provided `filename_react` args in app; Use It
        if(isTruthy(filename_react())){
          
          filename_react()
          
        }else{
          # Otherwise, use static file name
          filename
        }
        
      })
      
      output$download_xlsx <- downloadHandler(
        
        filename = function() paste0(file_name()),
        content = function(file){
          
          write_gV.xlsx(..., filename = file)
          
        }
        
      )
      
      # output$raw <- renderPrint({ 
      #   
      #   list(filename_react = filename_react(),
      #        filename_react_isTruthy = isTruthy(filename_react()),
      #        file_name = file_name())
      #   })
      
    }
  )
}
