library(class)
library(randomForest)

wine = read.csv("description-50.csv")
wine = na.exclude(wine)
wine = wine[sample(1:nrow(wine), 25000),]

scale = function(x){
  result = (x - min(x)) / (max(x) - min(x))
}

wine$price = scale(wine$price)

detach(wine)
attach(wine)

size = nrow(wine)
training = sample(1:size, size*0.75)
training.set = wine[training,]
testing.set = wine[-training,]

points.column = 51

training.y = training.set$points
training.x = training.set[, -points.column]
testing.x = testing.set[, -points.column]
testing.y = testing.set$points

knn1 = knn(training.x, testing.x, training.y, k=1)
knn3 = knn(training.x, testing.x, training.y, k=3)
knn5 = knn(training.x, testing.x, training.y, k=5)
knn15 = knn(training.x, testing.x, training.y, k=15)

table(knn1, testing.y)
table(knn3, testing.y)
table(knn5, testing.y)
table(knn15, testing.y)
