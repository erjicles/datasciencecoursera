library(shiny)
library(e1071)
library(randomForest)
library(rpart)
library(gbm)
library(klaR)
library(MASS)
library(caret)
library(plotly)

shinyServer(function(input, output) {
    
    # Create the training data list based on the user-input % in the training set
    inTrain <- reactive({
        set.seed(input$seed)
        createDataPartition(y=iris$Species, p=input$pTrain, list=FALSE)
    })
    
    # Get the user-specified train control
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
    
    # Train the model on the training set
    fit <- reactive({
        training <- iris[inTrain(),]
        train(Species ~ ., data=training, method=input$modelType, trControl=tr())
    })
    
    # Predict the species on the testing set
    predFit <- reactive({
        testing <- iris[-inTrain(),]
        predict(fit(), testing)
    })
    
    # Add the predicted species to the dataset
    updatedTesting <- reactive({
        testing <- iris[-inTrain(),]
        cbind(testing, PredictedSpecies = predFit())
    })
    
    # Get a confusion matrix of the results
    confFit <- reactive({
        uTesting <- updatedTesting()
        confusionMatrix(uTesting$Species, uTesting$PredictedSpecies)
    })
    
    # Output the prediction accuracy on the testing dataset
    output$accuracy <- renderText({
        confFit()$overall["Accuracy"]
    })
    
    # Output a plotly graph of the actual and predicted species
    output$plot1 <- renderPlotly({
        uTesting <- updatedTesting()
        levels(uTesting$PredictedSpecies) <- paste(levels(uTesting$PredictedSpecies), " (Predicted)")
        levels(uTesting$Species) <- paste(levels(uTesting$Species), " (Actual)")
        plot_ly(uTesting, x=~Petal.Width, y=~Sepal.Width, color=~Species, symbol=~PredictedSpecies, type="scatter", mode="markers")
    })
    
})