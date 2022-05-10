library(nnet)
library(caret)
library(randomForest)

wine = read.csv("description-50.csv")
wine = na.roughfix(wine)

scale = function(x){
  result = (x - min(x)) / (max(x) - min(x))
}

wine$price = scale(wine$price)

attach(wine)

size = nrow(wine)
training = sample(1:size, size*0.8)
training.set = wine[training,]
testing.set = wine[-training,]
testing.set = na.roughfix(testing.set)

control = trainControl(method = "cv", number = 10)
model.cnn = train(points ~ .,
                  data = wine,
                  subset = training,
                  method = "nnet",
                  na.action = na.roughfix,
                  linout = TRUE,
                  trControl = control)

model.cnn

predicts = round(predict(model.cnn, testing.set))

sum(abs(predicts - testing.set$points)) / nrow(testing.set)
sum((predicts - testing.set$points)^2) / nrow(testing.set)
sqrt(sum((predicts - testing.set$points)^2) / nrow(testing.set))

a = table(predicts, testing.set$points)
a

write.csv(a, "cnn-confusion.csv")
