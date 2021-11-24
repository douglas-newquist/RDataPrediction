library(tree)
library(randomForest)
library(ggplot2)


panel.hist <- function(x, ...)
{
  usr <- par("usr")
  par(usr = c(usr[1:2], 0, 1.5) )
  h <- hist(x, plot = FALSE)
  breaks <- h$breaks; nB <- length(breaks)
  y <- h$counts; y <- y/max(y)
  rect(breaks[-nB], 0, breaks[-1], y)
}

panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...)
{
  usr <- par("usr")
  par(usr = c(0, 1, 0, 1))
  r <- cor(x, y, use = "complete.obs")
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <- paste0(prefix, txt)
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r)
}

plot.pairs = function(file, out.png){
  data = read.csv(file)
  png(out.png, width = 1000, height = 1000)
  pairs(data, upper.panel = panel.cor, diag.panel = panel.hist)
  dev.off()
}

plot.pairs("description-word-frequency.csv", "description.png")
plot.pairs("designation-word-frequency.csv", "designation.png")
plot.pairs("title-word-frequency.csv", "title.png")

wine = read.csv("tokenized.csv")
wine.filtered = wine[,c("country", "points", "price", "province", "region_1", "region_2", "taster_name", "variety", "winery")]

png("wine.png", width = 1000, height = 1000)
plot(wine.filtered, upper.panel = panel.cor, diag.panel = panel.hist)
dev.off()