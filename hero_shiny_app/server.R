library(shiny)

#set working directory
setwd(file.path(getwd()))

#load libraries
library(e1071)
library(caret)
library(randomForest)
library(ggplot2)
library(plyr)
library(dplyr)
library(stats)

#Load data
favhero <-read.csv("data/hero.csv", strip.white=T, na.strings="undefined", header = TRUE)
favhero<-select(favhero, -1) ## take out extra rowname row
newhero<-NULL #set a placeholder for new data
newrow<-NULL

#Trains the model
ctrl <<- trainControl(allowParallel=T, method="cv", number=4)
model<<- train(Superhero ~ ., data=favhero[,1:12], trControl=ctrl, method="rf")

##set start ID value
Id<-001

## set default values
temp<-favhero[1,]
y<-c(25, 0, "Male", "Neutral", "Neutral", "Spiderman", "Flight", 0,0,0,0,0, "1")
temp$Date<-date()
temp[1,1:13]<-y
default<<-temp


shinyServer(function(input, output) {
        
        prediction<<-NULL #resets the prediction variable
        dts<<-date() #updates the date field with a date-time-stamp
        Id<<-sum(Id+1) #adds a session IDnew
        
        selectedData<-default #loads the default data
  
        #retrain the model 
        if(is.null(newhero)){
                model<<-model
        }else{
                model<<- train(Superhero ~ ., data=newhero[,1:12], trControl=ctrl, method="rf")
        }
        #watch to see if any user inputs change and update data
        userInputs<- reactive({
                selectedData$Superhero<-input$hero
                selectedData$Gender<-input$gender
                selectedData$Age<-input$age
                if(input$parental.status != ""){
                        selectedData$Parental.Status<-input$parental.status
                }
                if(input$movies.future != ""){
                        selectedData$Movies.Future.Year<-input$movies.future
                }
                if(input$merch.future != ""){
                        selectedData$Merch.Future.Year<-input$merch.future
                }
                if(input$power != ""){
                        selectedData$Power<-input$power
                }
                selectedData$Creative<-input$creativity 
                selectedData$Introverted<-input$introverted 
                selectedData$Agreeable<-input$agreeable 
                selectedData$DoGooder<-input$dogooder
                selectedData$Strength<-input$strength 
                selectedData$Id<-Id 
                selectedData$Date<-dts 
                return(selectedData)
        })
        
        Outcome<-reactive({
                nd<-userInputs()
                outcome<-predict(model, newdata=nd[,1:12]) 
                outcome<-as.character(outcome)
                return(outcome)
        })
        
        output$choice <- renderImage({ 
                # When input$hero is wonder.woman, filename is ./images/wonder.woman.jpeg
                if(input$hero!=""){
                        filename <- normalizePath(file.path('./www/images', paste(input$hero, '.jpg', sep=''))) 
                }else{
                        filename <- normalizePath(file.path('./www/images', "default.jpg"))}
                list(src = filename)
        }, deleteFile = FALSE)
        
        output$guess <- renderImage({
                prediction<-Outcome()
                if(input$hero!="" & input$power!=""){
                        filename <- normalizePath(file.path('./www/images', paste(prediction, '.jpg', sep=''))) 
                }else{
                filename <- normalizePath(file.path('./www/images', "default.jpg"))}
                list(src = filename)
        }, deleteFile = FALSE)
        
        
        observeEvent(input$doneButton, {
                newrow<<-userInputs()
        })
        
        output$check<-renderText({
                input$doneButton
                finalchoice<-Outcome()
                if(input$hero == finalchoice){
                        return("Success")
                        }else{
                        return("No luck. Thanks anyway!")	
                }
        })
        newhero<<-rbind(newhero, newrow)
        })