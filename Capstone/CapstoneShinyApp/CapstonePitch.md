Capstone Pitch
========================================================
author: Erik Johnson
date: 1/25/2018
autosize: true

Summary
========================================================
In this project, our goal was to create a shiny app that accepts user text as input, and predicts the likeliest next word as output. To achieve this, first we created a prediction model that predicts the next word of a given phrase. Second, we published a shiny app that allows users to input their own phrases, runs the phrases against our prediction model, and outputs the predicted next word.

Prediction Algorithm
========================================================

Our algorithm uses a database of 1-6-grams and their corresponding frequencies of appearance in the corpora. It takes the tail of the user input, converts it into 1-5-grams, and attempts to look up matching 1-5-gram bases in the database. Once all n-grams with a matching base are found, it returns the one with the most frequent final word as its prediction. It first attempts to match 5-gram bases, and if none are found, moves to 4-gram bases, and so on. If no matches are found, then it returns the most frequent starting word.

Performance
========================================================



Test Data: We test our prediction model against the quanteda built-in corpus `data_corpus_inaugural`, a compilation of various inaugural addresses from U.S. presidents.

Runtime: Using 20 random sentences from the test data, we find that the algorithm on average takes 2.17 seconds per prediction.

Accuracy: Using 20 random sentences from the test data, we find that the model predicts the actual next word with 20% accuracy.

Shiny App
========================================================

The Shiny app provides a textbox for you to type in your phrase. It also has a checkbox for you to select whether or not you want to block profanity, simulating parental controls. 

Once you've made your selections, click the "Submit" button. The app will process your input and display the three most likely predicted words.

Please visit the app here: https://erjicles.shinyapps.io/CapstoneShinyApp/
Thank you for your time!
