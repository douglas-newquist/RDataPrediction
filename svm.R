library(class)
library(caret)
library(randomForest)
library(e1071)

wine = read.csv("description-50.csv")

attach(wine)

size = nrow(wine)
training = sample(1:size, size*0.5)
training.set = wine[training,]
testing.set = wine[-training,]
testing.set = na.roughfix(testing.set)

control = trainControl(method = "cv", number = 10)
model.linear = svm(points ~ price,
                   data = wine,
                   subset = training,
                   kernel = "linear",
                   na.action = na.roughfix,
                   method = "svm",
                   trControl = control)

model.linear

predicts.linear = round(predict(model.linear, testing.set))

sum(abs(predicts.linear - testing.set$points)) / nrow(testing.set)
sum((predicts.linear - testing.set$points)^2) / nrow(testing.set)
sqrt(sum((predicts.linear - testing.set$points)^2) / nrow(testing.set))

a = table(predicts.linear, testing.set$points)
a

write.csv(a, "svm-linear-confusion.csv")

control = trainControl(method = "cv", number = 10)
model.poly = svm(points ~ price,
                 data = wine,
                 subset = training,
                 kernel = "polynomial",
                 degree = 2,
                 na.action = na.roughfix,
                 method = "svm",
                 trControl = control)
model.poly
 
predicts.poly = round(predict(model.poly, testing.set))

sum(abs(predicts.linear - testing.set$points)) / nrow(testing.set)
sum((predicts.poly - testing.set$points)^2) / nrow(testing.set)
sqrt(sum((predicts.poly - testing.set$points)^2) / nrow(testing.set))

b = table(predicts.poly, testing.set$points)
b

write.csv(b, "svm-poly-confusion.csv")
