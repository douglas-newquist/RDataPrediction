library(tree)
library(randomForest)
library(e1071)

wine = read.csv("tokenized.csv")
attach(wine)

size = nrow(wine)
training = sample(size, floor(size * 0.75))
testing = wine[-training,]

wine.price.tree = tree(points~price,
                       data = wine,
                       subset = training,
                       na.action = na.exclude)

png("wine-price-tree.png", width = 460, height = 460)
plot(wine.price.tree)
title("Predicting wine score from only price")
text(wine.price.tree)
dev.off()

predictions = predict(wine.price.tree, testing)
table(testing$points, predictions)

errors = testing$points - predictions
mean.square.error = sum(errors^2) / nrow(testing)
mean.error = sqrt(mean.square.error)

mean.error

summary(wine.price.tree)
