#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Capstone Shiny App"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
        textInput("inputPhrase", "Phrase:", value=""),
        checkboxInput("filterProfanity", "Filter profanity", value=TRUE),
        submitButton("Submit")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       textOutput("prediction1"),
       textOutput("prediction2"),
       textOutput("prediction3")
    )
  )
))
