### Zoom Interface Server


library(shiny)
library(markdown) 
library(readzoom)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
    #bslib::bs_themer(gfonts = TRUE, gfonts_update = FALSE)
    zoom_chat_Server("zoom_chat")

})
