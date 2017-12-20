library(shiny)
library(plotly)

shinyUI(fluidPage(
    titlePanel("Predicting Iris Species: An Interactive Machine Learning Model"),
    sidebarLayout(
        sidebarPanel(
            numericInput("seed", "Random seed", 24256, min=1, max=NA, step=1),
            sliderInput("pTrain", "% Training", 0.25, 0.9, value=0.6, step=0.01),
            radioButtons("modelType", "Model type", choices=c("rf", "rpart", "gbm", "nb", "lda")),
            radioButtons("trainControl", "Train control", choices=c("none", "bootstrap", "cross-validation")),
            sliderInput("cvFolds", "# folds", 3, 20, value=10),
            sliderInput("bootCount", "# bootstraps", 1, 50, value=25),
            submitButton("Submit")
        ),
        mainPanel(
            tabsetPanel(type="tabs", 
                tabPanel(
                    "Model", 
                    br(),
                    h3("Model out-of-sample accuracy"),
                    textOutput("accuracy"),
                    h3("Actual and Predicted Species"),
                    plotlyOutput("plot1")),
                tabPanel(
                    "Documentation", 
                    br(), 
                    h3("Documentation"),
                    "This app creates an interactive machine learning model (using the caret package) that aims to predict the species of plants based on the iris dataset.",
                    br(),br(),
                    "The model splits the iris dataset into training and testing datasets. Then, it trains the model on the training dataset and estimates the out-of-sample accuracy on the testing dataset.",
                    "It also displays a plot (using plotly) of the predicted and actual species.",
                    br(),br(),
                    "Several inputs allow the user to configure the model:",
                    br(),br(),
                    tags$b("Random seed: "),
                    "The random seed for training the model. This allows for reproducibility.",
                    br(),br(),
                    tags$b("% training: "),
                    "The percent of the iris dataset in the training set. The remainder goes into the testing dataset.",
                    br(),br(),
                    tags$b("Model type: "),
                    "The type of machine learning algorith to use when training the model.",
                    br(),br(),
                    tags$b("Train control: "),
                    "The type of pre-processing to use when training the model.",
                    br(),br(),
                    tags$b("# Bootstraps: "),
                    "If Train control is bootstrap, then the number of bootstraps to use.",
                    br(),br(),
                    tags$b("# Folds: "),
                    "If Train control is cross-validation, then the number of folds to use."
                )
            )
        )
    )
))