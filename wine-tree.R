library(tree)
library(randomForest)
library(e1071)

wine = read.csv("tokenized.csv")
attach(wine)

size = nrow(wine)
training = sample(size, floor(size * 0.75))
testing = na.roughfix(wine[-training,])

wine.price.tree = tree(points ~ price,
                       data = wine,
                       subset = training,
                       na.action = na.roughfix)

png("wine-price-tree.png", width = 460, height = 460)
plot(wine.price.tree)
title("Predicting wine score from only price")
text(wine.price.tree)
dev.off()

predictions = round(predict(wine.price.tree, testing))
a = table(predictions, testing$points)
a

write.csv(a, "tree-confusion.csv")

errors = testing$points - predictions
sum(abs(testing$points - predictions)) / nrow(testing)
sum(errors^2) / nrow(testing)
sqrt(sum(errors^2) / nrow(testing))

summary(wine.price.tree)
