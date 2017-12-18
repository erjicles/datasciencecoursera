library(shiny)
library(plotly)

shinyUI(fluidPage(
    titlePanel("Predict Species (iris data)"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("pTrain", "% Training", 0.25, 0.9, value=0.6, step=0.01),
            radioButtons("modelType", "Model type", choices=c("rf", "rpart", "gbm", "nb", "lda")),
            radioButtons("trainControl", "Train control", choices=c("none", "bootstrap", "cross-validation")),
            sliderInput("cvFolds", "# folds", 3, 20, value=10),
            sliderInput("bootCount", "# bootstraps", 1, 50, value=25),
            submitButton("Submit")
        ),
        mainPanel(
            h3("Model out-of-sample accuracy"),
            textOutput("accuracy"),
            h3("Actual and Predicted Species"),
            plotlyOutput("plot1")
        )
    )
))