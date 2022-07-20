library(ggplot2)


#Reading the data-------------------------------
cuckoo <- read.csv("data/raw/valletta_cuckoo.csv")


#Testing different hypothesis -------------------
h1 <- glm(Beg ~ Mass, data = cuckoo,
          family = poisson(link = log))

h2 <- glm(Beg ~ Mass + Species, data = cuckoo,
          family = poisson(link = log))

h3 <- glm(Beg ~ Mass * Species, data = cuckoo,
          family = poisson(link = log))

h0 <- glm(Beg ~ 0, data = cuckoo,
          family = poisson(link = log))


#Predicted values ------------------------------
