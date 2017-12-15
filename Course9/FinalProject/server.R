library(shiny)
library(caret)
library(plotly)

shinyServer(function(input, output) {
    
    inTrainSet <- createDataPartition(y=iris$Species, p=0.6, list=FALSE)
    training <- iris[inTrain,]
    testing <- iris[-inTrain,]
    #pTrain <- input$pTrain
    #inTrainSet <- createDataPartition(y=iris$Species, p=pTrain, list=FALSE)
    #training <- iris[inTrainSet,]
    #testing <- iris[-inTrainSet,]
    
    tr <- reactive({
        if (input$trainControl == "none") {
            trainControl(method="none")
        } else if (input$trainControl == "bootstrap") {
            trainControl(method="boot", input$bootCount)
        } else if (input$trainControl == "cross-validation") {
            trainControl(method="cv", input$cvFolds)
        } else {
            trainControl(method="none")
        }
    })
    
    fit <- reactive({
        train(Species ~ ., data=training, method=input$modelType, trControl=tr())
    })
    
    predFit <- reactive({
        predict(fit(), testing)
    })
    
    updatedTesting <- reactive({
        cbind(testing, PredictedSpecies = predFit())
    })
    
    confFit <- reactive({
        uTesting <- updatedTesting()
        confusionMatrix(uTesting$Species, uTesting$PredictedSpecies)
    })
    
    output$accuracy <- renderText({
        confFit()$overall["Accuracy"]
    })
    
    output$plot1 <- renderPlotly({
        uTesting <- updatedTesting()
        plot_ly(uTesting, x=~Petal.Width, y=~Sepal.Width, color=~Species, symbol=~PredictedSpecies)
    })
    
})