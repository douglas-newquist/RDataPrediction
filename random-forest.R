library(class)
library(caret)
library(randomForest)

wine = read.csv("description-50.csv")
wine = na.exclude(wine)

#detach(wine)
attach(wine)

size = nrow(wine)
training = sample(1:size, floor(size*0.5))
training.set = wine[training,]
testing.set = wine[-training,]

control = trainControl(method = "cv", number = 10)
model.forest = randomForest(points ~ .,
                     training.set,
                     ntrees = 25,
                     max.depth = 4,
                     trControl = control)

model.forest

predicts = round(predict(model.forest, testing.set))

sum(abs(predicts - testing.set$points)) / nrow(testing.set)
sum((predicts - testing.set$points)^2) / nrow(testing.set)
sqrt(sum((predicts - testing.set$points)^2) / nrow(testing.set))

a = table(predicts, testing.set$points)
a

write.csv(a, "random-confusion.csv")
