# kas-hero-app
# Student: Kate Stohr 
# Coursera Data Science Certification 
# Data Products, 

library(shiny)

dataset<-favhero<-read.csv("data/hero.csv", strip.white=T, na.strings="undefined")
        
shinyUI(fluidPage(
        
       
        title = "Favorite Superhero",
        
        fluidRow(
                column(12,
                      h1("Favorite Superhero"),
                      h4("Choose a hero, and I'll try to guess which one you chose.")
                      )
                ),
        fluidRow(
                column(6, align="center",
                       h4("Your Choice"),
                       imageOutput("choice", width = "100%", height = "300px", inline = FALSE)   
                ),
                column(6, align="center",
                       h4("My Guess"),
                       imageOutput("guess", width = "100%", height = "300px", inline = FALSE)
                )
        ),
        fluidRow(
                column(12, align="center",
                       actionButton("doneButton", "Done"),
                       conditionalPanel(
                               condition = "input.doneButton >= 1",
                               h3(textOutput("check"))
                       )
                )
        ),
        
        hr(),
        fluidRow(
                column(4,
                       wellPanel(
                               h4("1. Choose a hero."),
                               selectizeInput('hero', 'Superhero',
                                              choices = c(Choose='', levels(favhero$Superhero)))
                       )),
                
                column(4,
                       wellPanel(
                               h4("2. Tell me about yourself."),
                               selectizeInput('power',
                                              "Which of these superpowers would you most like to possess?",
                                              choices=sample(levels(favhero$Power), size=3, replace=FALSE),
                                              options = list(
                                                      placeholder = 'Choose',
                                                      onInitialize = I('function() { this.setValue(""); }')
                                              )
                               ),
                               radioButtons("gender", "Gender",
                                            c("Female" = "Female",
                                              "Male" = "Male"), selected = NULL, inline=TRUE),
                               numericInput('age', 'Age', value = 25, min = 1, max = 100),
                               
                               selectizeInput(
                                       'parental.status', 'How many children do you have?',
                                       choices = levels(favhero$Parental.Status),
                                       options = list(
                                               placeholder = 'Choose',
                                               onInitialize = I('function() { this.setValue(""); }')
                                       )
                               ),
                               
                               selectizeInput(
                                       'movies.future', 
                                       'How likely are you to watch a superhero film in the coming year?',
                                       choices = levels(favhero$Movies.Future.Year),
                                       options = list(
                                               placeholder = 'Choose',
                                               onInitialize = I('function() { this.setValue(""); }')
                                       )
                               ),
                               
                               selectizeInput('merch.future',
                                              'How likely are you to buy superhero merchandise in the coming year?',
                                              choices=levels(favhero$Merch.Future.Year),
                                              options = list(
                                                      placeholder = 'Choose',
                                                      onInitialize = I('function() { this.setValue(""); }')
                                              )
                               )
                       )),
                       
                column(4,
                       wellPanel(
                               h4("3. Ok, give me a hint."), 
                               
                               h6("Select the trait that best describes the hero you chose."), 
                               
                               sliderInput("creativity", label = ("Creative vs. Hardworking?"), 
                                           min = 0, max = 1, value = 0, step = 1), 
                               sliderInput("introverted", label = ("Introverted vs. Extroverted?"), 
                                           min = 0, max = 1, value = 0, step = 1),
                               sliderInput("agreeable", label = ("Agreeable vs. Moody?"), 
                                           min = 0, max = 1, value = 0, step = 1),
                               sliderInput("dogooder", label = ("Do Gooder vs. Rule Breaker?"), 
                                           min = 0, max = 1, value = 0, step = 1),
                               sliderInput("strength", label = ("Strength vs. Agility?"), 
                                           min = 0, max = 1, value = 0, step = 1)
                       )), 
                hr(),
                fluidRow(
                        column(12, align="left", offset = 1,
                               h6("Documentation:"),
                               h6("Select your favorite hero and identify which power you'd most like to possess. The application will 'predict' which hero is most likely your favorite based on the inputs given using a model built with Random Forests from a survey of 400 respondents.  As you update your inputs, the application updates it's prediction. When you are done, click 'done.'. The application will check to see if it guessed correctly and print a corresponding message. Your inputs are then stored in the dataframe to improve the model with use."), 
                               h6("Data Source:"),
                               h6("Data provided courtesy of: Ask Your Target Market"),
                               h6("[Superman](https://aytm.com/surveys/353802/stat/754346b79e6a9eeb44b8d64edfe1c520)")
                               )),
                hr()
                              
        )))