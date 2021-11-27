library(class)
library(randomForest)

wine = read.csv("description-25.csv")
wine = na.exclude(wine)

detach(wine)
attach(wine)

size = nrow(wine)
training = sample(1:size, 10000)
training.set = wine[training,]
testing.set = wine[-training,]

model = randomForest(points ~ .,
                     training.set,
                     num.trees=100,
                     max.depth=8)

predicts = predict(model, testing.set)
sum((predicts - testing.set$points)^2) / nrow(testing.set)
