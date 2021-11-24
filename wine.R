library(tree)
library(randomForest)
library(e1071)

wine = read.csv("tokenized.csv")[, c("points", "price")]

detach(wine)
attach(wine)

plot(points, price)

size = nrow(wine)
training = sample(size, floor(size * 0.75))
testing.set = wine[-training,]
training.set = wine[training,]

price.linear = svm(points ~ price,
                   data = wine,
                   subset = training,
                   kernel = "linear",
                   na.action = na.roughfix)

price.linear

train.predict = predict(price.linear, training.set, na.action = na.roughfix)
test.predict = predict(price.linear, testing.set, na.action = na.roughfix)

table(round(test.predict), testing.set$points)
table(round(train.predict), training.set$points)

train.mean.sqaure.error = sum((training.set$points - train.predict)^2) / nrow(training.set)
test.mean.square.error = sum((testing.set$points - test.predict)^2) / nrow(testing.set)


price.poly = svm(points ~ price,
                 data = wine,
                 subset = training,
                 kernel = "polynomial",
                 degree = 2,
                 na.action = na.roughfix)

price.poly
