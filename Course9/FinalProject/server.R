library(shiny)
library(caret)
library(plotly)

shinyServer(function(input, output) {
    
    inTrain <- reactive({
        createDataPartition(y=iris$Species, p=input$pTrain, list=FALSE)
    })
    
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
        training <- iris[inTrain(),]
        train(Species ~ ., data=training, method=input$modelType, trControl=tr())
    })
    
    predFit <- reactive({
        testing <- iris[-inTrain(),]
        predict(fit(), testing)
    })
    
    updatedTesting <- reactive({
        testing <- iris[-inTrain(),]
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
        levels(uTesting$PredictedSpecies) <- paste(levels(uTesting$PredictedSpecies), " (Predicted)")
        levels(uTesting$Species) <- paste(levels(uTesting$Species), " (Actual)")
        plot_ly(uTesting, x=~Petal.Width, y=~Sepal.Width, color=~Species, symbol=~PredictedSpecies, type="scatter", mode="markers")
    })
    
})