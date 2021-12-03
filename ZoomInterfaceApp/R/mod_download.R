### Download list of DF as excel file

library(shiny)
library(purrr)

# Function: Write Custom Excel -------------------------------------------------------------

write_custom.xlsx <- function(x, filename){
  
  
  # Create Header Style
  head_style <- openxlsx::createStyle(textDecoration = "bold", 
                                      halign = "center", valign = "center", 
                                      fgFill = "#d9ead3", 
                                      border = "TopBottomLeftRight")
  
  wb <- openxlsx::write.xlsx(x, filename, 
                             headerStyle = head_style, 
                             borders = "columns")
  # Freeze First Row
  purrr::walk(names(x) , ~openxlsx::freezePane(wb, sheet = .x ,firstRow = T) )
  
  openxlsx::saveWorkbook(wb,  filename, overwrite = T)
  
}

# UI: Download botton -----------------------------------------------------


download_xlsx_UI <- function(id, botton_labs = "Download") {
  ns <- NS(id)
  tagList(
    shiny::downloadButton(ns("download_xlsx"), botton_labs),
    #verbatimTextOutput(ns("raw"))
  )
}


# Server: write excel -----------------------------------------------------




#' Download Excel Server
#' 
#' When providing reactive file name to `filename_react`, DO NOT wrap parenthesis around it.
#' If you want to construct file name, it must be constricted to a single reactive object
#' before passing to this argument.
#'
#' @param id shiny ID
#' @param x reactive object to download
#' @param filename (static) file name
#' @param filename_react (reactive) reactive file name. If provided, ignore `filename`
#'
#' @return Nothing
download_xlsx_Server <- function(id,
                                 x,
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
          
          write_custom.xlsx(x, file)
          
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
