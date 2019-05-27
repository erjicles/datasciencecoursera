# Capstone Project

Course: Coursera Data Science Specialization  
Author: Erik Johnson  
Date: 02/10/2018

## Objective

This capstone project had two objectives:

1. Create a Shiny app that accepts user text as input, and predicts the 
likeliest next word as output. 

2. Publish to RPubs a 5-slide pitch for the Shiny app.

The final pitch and Shiny app can be viewed here:


[Capstone Pitch](http://rpubs.com/erjicles/358449)  
[Shiny App](https://erjicles.shinyapps.io/CapstoneShinyApp/)

## Methodology

The idea of the project is to analyze a large corpus of text and create
a machine learning model that predicts the next likeliest word given
some input text.

We start by downloading the course dataset provided [here](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip).
The data consists of three corpus files containing text from blogs, 
news articles, and twitter, respectively. We randomly split the corpus
into training and test sets. We build the prediction model utilizing 
the training set and validate it against the test data set.

We design our prediction model to utilize [n-gram](https://en.wikipedia.org/wiki/N-gram)
frequencies within the data. We analyze the corpus to create tables
of n-grams, where n runs from 2 to 6. To predict the next word given
an input string, we start by taking the tail 5 words of the input (or the
whole string if less than 5), and searching for 6-grams that begin with
those input words. If 6-grams are found, we take the one that appears
most frequently in the table (or randomly if there is a tie) and return
the tail word of the 6-gram as the likeliest next word.

If no 6-grams are found, we take the tail 4 words of the input and
search for 5-grams in the data that begin with those 4 input words. We
repeat this process in a similar fashion as above, until an n-gram
is found that matches the input and returned as a prediction.

If no n-grams are found down to n=2 (meaning that a given input word
never appears in the data), then we simply pick a word from the corpus
at random.

### Improving Performance

The above methodology generates extremely large n-gram tables (over 20GB).
Given that the course asks us to deploy the solution as a shiny app for free at
shinyapps.io, we don't have a SQL database to utilize and are constrained
to ~250MB file storage for the app. The course also asks for decent
app performance - that is, it should return a prediction within a couple
of seconds.

Given the above, we need to reduce the size of our n-gram tables to a
deployable size that also allows for quick searches. To accomplish this,
we first eliminate all n-grams with a frequency of 1. This successfully
reduced the size of the n-gram table files to a size deployable to
shinyapps.io. Next, to allow for quick searches, we split the n-gram
tables into multiple files, first splitting on n-gram size (n=2 to 6),
and next splitting by the first letter of the first word in the n-gram.
Further, whithin each file, we sort the n-grams alphabetically.

These steps successfully allowed us to return results for any given
input string within 1-2 seconds.

## Generating the App Data

We read the corpus and generate n-gram files using prepare_ngrams.Rmd.

Next, we reduce the n-grams to a manageable size by removing all n-grams
that only appear once in the dataset using filter_ngrams.Rmd. Ensure
you update the destinationDirectory variable to a directory of your
choosing when doing this.

This results in the set of n-gram files to be used by the shiny app.

## Shiny App

The shiny app is a basic shiny app with ui.R and server.R files.

The meat of the app happens in server.R. The program takes the user
input and then passes it into the predictNext function in the
prediction_algorithm.R file. This function then searches the
n-gram files for the given input, as described above, and returns
a primary and two alternative predictions.

The app also provides a profanity filter. It utilizes the
[profanity_google](https://www.rdocumentation.org/packages/lexicon/versions/0.7.4/topics/profanity_google)
R dataset and never returns a prediction contained in that dataset.
