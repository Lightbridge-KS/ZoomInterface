#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(markdown) 

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
    #bslib::bs_themer(gfonts = TRUE, gfonts_update = FALSE)
    zoom_chat_Server("zoom_chat")

})
