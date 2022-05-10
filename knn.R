library(class)
library(caret)
library(randomForest)

wine = read.csv("description-50.csv")
wine = na.exclude(wine)
#wine = wine[sample(1:nrow(wine), 25000),]

scale = function(x){
  result = (x - min(x)) / (max(x) - min(x))
}

wine$price = scale(wine$price)

attach(wine)

size = nrow(wine)
training = sample(1:size, 20000)
training.set = wine[training,]
testing.set = wine[-training,]

control = trainControl(method = "cv", number = 10)
model.knn = train(points ~ .,
              data = training.set,
              method = "knn",
              trControl = control)

model.knn

predicts = round(predict(model.knn, testing.set))

sum(abs(predicts - testing.set$points)) / nrow(testing.set)
sum((predicts - testing.set$points)^2) / nrow(testing.set)
sqrt(sum((predicts - testing.set$points)^2) / nrow(testing.set))

a = table(predicts, testing.set$points)
a

write.csv(a, "knn-confusion.csv")
