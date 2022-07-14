# --------------------------------------------------#
# Scientific computing
# ICTP/Serrapilheira 2022
# Script to perform exploratory data analysis
# For more explanations follow the tutorial at:
# First version 2022-07-13
# --------------------------------------------------#

# Loading the data
data(iris)

head(iris)
summary(iris)

## The functions `aggregate` and `tapply` --------------------------------------

table(iris$Species)

# sepal length mean per species
tapply(X = iris$Sepal.Length, INDEX = list(iris$Species), FUN = mean)
# the same operation, using another function, other arguments and other output
aggregate(x = iris$Sepal.Length, by = list(iris$Species), FUN = mean)
# still the same operation, the same function but a different notation
aggregate(Sepal.Length ~ Species, data = iris, mean)


## NAs and zeroes --------------------------------------------------------------
apply(iris, 2, function(x) sum(is.na(x)))

## Descriptive statistics ------------------------------------------------------
vars <- iris[, -5]

### Measures of central tendency
apply(vars, 2, mean)

apply(vars, 2, median)

freq_sl <- sort(table(iris$Sepal.Length), decreasing = TRUE)
freq_sl[1]

### Measures of dispersion
apply(vars, 2, var)

sd01 <- apply(vars, 2, sd)
# another way:
sd02 <- apply(vars, 2, function(x) sqrt(var(x)))
sd01
sd02
sd01 == sd02


cv <- function(x){
  sd(x) / mean(x) * 100
}
apply(vars, 2, cv)


# quartiles (four quantiles)
apply(vars, 2, quantile)
# 5%, 50% e 95%
apply(vars, 2, quantile, probs = c(0.05, 0.5, 0.95))


# range function return the min and max
apply(vars, 2, range)
# applying the diff function to the range result, we have the desired value
# a good practice is to never overwrite an existing object in R, so
# never name an object with an already existing name
my_range <- function(x){
  diff(range(x))
}
apply(vars, 2, my_range)


apply(vars, 2, IQR)

# Correlation ------------------------------------------------------------------
cor(vars)

# Graphical methods ------------------------------------------------------------
barplot(table(iris$Species))


par(mfrow = c(2, 2))
hist(iris$Sepal.Length)
hist(iris$Sepal.Width)
hist(iris$Petal.Length)
hist(iris$Petal.Length)
par(mfrow = c(1, 1))

par(mfrow = c(1, 2))
hist(iris$Sepal.Width)
hist(iris$Sepal.Width, breaks = 4)
par(mfrow = c(1, 1))


par(mfrow = c(1, 2))
hist(iris$Sepal.Width)
hist(iris$Sepal.Width, freq = FALSE)
par(mfrow = c(1, 1))


par(mfrow = c(1, 2))
# ploting the density curve
plot(density(iris$Sepal.Width))
#  ploting the density curve over the density histogram
hist(iris$Sepal.Width, freq = FALSE)
lines(density(iris$Sepal.Width), col = "blue")
par(mfrow = c(1, 1))

boxplot(iris$Sepal.Length)
boxplot(iris$Sepal.Width)
boxplot(iris$Petal.Length)
boxplot(iris$Petal.Width)


boxplot(Sepal.Length ~ Species, data = iris)
boxplot(Sepal.Width ~ Species, data = iris)
boxplot(Petal.Length ~ Species, data = iris)
boxplot(Petal.Width ~ Species, data = iris)


boxplot(iris$Sepal.Width)
my_boxplot <- boxplot(iris$Sepal.Width, plot = FALSE)
my_boxplot
# the object is a list and the outliers are stored in the $out element of the list
outliers <- my_boxplot$out
# what is the position of the outliers
which(iris$Sepal.Width %in% outliers)
# let's use the position to index the object
iris[which(iris$Sepal.Width %in% outliers), c("Sepal.Width", "Species")]


boxplot(Sepal.Width ~ Species, data = iris)
my_boxplot2 <- boxplot(Sepal.Width ~ Species, data = iris, plot = FALSE)
my_boxplot2
# the object is a list and the outliers are stored in the $out element of the list
outliers2 <- my_boxplot2$out
# in this case, we only want the outliers of the setosa species
# let's use the position to index the object
iris[iris$Sepal.Width %in% outliers2 &
       iris$Species == "setosa",
     c("Sepal.Width", "Species")]


# Checking if the data follow a normal distribution ----------------------------

par(mfrow = c(1, 3))
qqnorm(iris$Sepal.Length[iris$Species == "setosa"],
       main = "setosa")
qqline(iris$Sepal.Length[iris$Species == "setosa"])
qqnorm(iris$Sepal.Length[iris$Species == "versicolor"],
       main = "versicolor")
qqline(iris$Sepal.Length[iris$Species == "versicolor"])
qqnorm(iris$Sepal.Length[iris$Species == "virginica"],
       main = "virginica")
qqline(iris$Sepal.Length[iris$Species == "virginica"])
par(mfrow = c(1, 1))


# Relationship between variables -----------------------------------------------

pairs(vars)


# EXCEPTIONALLY let's load the package now, as this is a bonus exercise.
library("GGally")
ggpairs(vars)
