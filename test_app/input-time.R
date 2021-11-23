### How to Input Time as HTML


library(shiny)

ui <- fluidPage(
  
  tags$label("Time:", `for` = "ui_time"),
  HTML('<input id="ui_time" type="time", value = ""><br>'),
  tags$script(HTML(
    'document.getElementById("ui_time").onchange = function() {
						var time = document.getElementById("ui_time").value;
						Shiny.setInputValue("time_html", time);
					};'
  )),

  
  h4(textOutput("output_html")),
  verbatimTextOutput("raw")
)

server <- function(input, output, session) {

  
  
  output$output_html  <- renderText({
    paste("Your have entered the following time: ", input$time_html)
  })
  
  output$raw <- renderPrint({
    list(input = input$time_html, 
         class = class(input$time_html)
    )
  })
  
}

shinyApp(ui, server)