### Zoom Interface Server


library(shiny)
library(markdown) 
library(ggplot2)
library(zoomclass)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
    #bslib::bs_themer(gfonts = TRUE, gfonts_update = FALSE)
    zoom_chat_Server("zoom_chat")
    zoom_participants_Server("zoom_pp")

})
