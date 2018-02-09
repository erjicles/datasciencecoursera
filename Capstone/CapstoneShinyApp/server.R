#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
source("prediction_algorithm.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    prediction <- reactive({
        predictNext(input$inputPhrase, input$filterProfanity)
    })
    
    output$prediction1 <- renderText({paste("Top predicted:", prediction()[1])})
    output$prediction2 <- renderText({paste("Alternative 1:", prediction()[2])})
    output$prediction3 <- renderText({paste("Alternative 2:", prediction()[3])})
2 
})
