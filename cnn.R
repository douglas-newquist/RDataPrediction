library(nnet)
library(caret)
library(randomForest)

wine = read.csv("description-25.csv")[1:25000,]
wine = na.exclude(wine)

detach(wine)
attach(wine)

size = nrow(wine)
training = sample(1:size, 10000)
training.set = wine[training,]
testing.set = wine[-training,]

control = trainControl(method = "cv", number = 10)
model = train(points ~ .,
              data = training.set,
              method = "nnet",
              trControl = control)

predicts = predict(model, testing.set)
sum((predicts - testing.set$points)^2) / nrow(testing.set)
