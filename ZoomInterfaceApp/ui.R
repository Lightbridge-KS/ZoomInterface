#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(markdown) 
library(ggplot2)
library(zoomclass)

# Define UI for application that draws a histogram
shinyUI(
    navbarPage("Zoom Interface",
               theme = bslib::bs_theme(bootswatch = "united",
                                       "enable-gradients" = TRUE, "enable-shadows" = TRUE,
                                       primary = "#2080E9", secondary = "#D5372F",
                                       font_scale = NULL
                                       ),
               tabPanel("About",
                        includeMarkdown("about.md") # Must add library(markdown) 
               ),
               zoom_participants_UI("zoom_pp"),
               zoom_chat_UI("zoom_chat")
               
                   
)
)
