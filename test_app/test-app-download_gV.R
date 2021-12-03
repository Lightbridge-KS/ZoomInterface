library(shiny)

ui <- fluidPage(
  
  download_xlsx_gV_UI("dl")
  
)

server <- function(input, output, session) {
  
  ir <- reactive({ iris[1:3, ] })
  mt <- reactive({ mtcars[1:3, ] })
  
  download_xlsx_gV_Server("dl", 
                          tab1 = list(ir(), mt()),
                          tab2 = list(ir()),
                          tab3 = list(ir()),
                          filename = "report.xlsx"
                          )
  
}

shinyApp(ui, server)