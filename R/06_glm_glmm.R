# --------------------------------------------------#
# Scientific computing
# ICTP/Serrapilheira 2022
# Inplementing glm and glmm in R
# First version 2022-07-20
# --------------------------------------------------#

# Loading needed packages
ibrary(dplyr)
library(lme4)
library(merTools)
library(ggplot2)


# Going back to lm to fit a Gaussian glm ---------------------------------------
f <- read.csv("data/raw/crawley_regression.csv")

lm(growth ~ tannin, data = df)



lm(growth ~ tannin, data = df, family = gaussian(link = identity))


## -Cuckoo glm--- ---------------------------------------------------------------
cuckoo <- read.csv("data/raw/valletta_cuckoo.csv")
summary(cuckoo)


## Visualizing the dataggplot(cuckoo, aes(x = Mass, y = Beg, colour = Species)) +
  geom_point() +
  theme_classic()


# Fitting a model with an interaction term
cuckoo_lm <- lm(Beg ~ Mass * Species, data = cuckoo)


# Inspecting the model
par(mfrow = c(2, 2))
plot(cuckoo_lm, pch = 19, col = 'darkgrey')
par(mfrow = c(1, 1))


# Fitting a glm
cuckoo_glm <- glm(Beg ~ Mass * Species, data = cuckoo,
           family = poisson(link = log))


summary(cuckoo_glm)


# Comparing lm and glm
par(mfrow = c(1, 2))
plot(cuckoo_lm, 1)
plot(cuckoo_glm, 1)
par(mfrow = c(1, 1))


# Calculating the predicted values
newdata <- expand.grid(Mass = seq(min(cuckoo$Mass), max(cuckoo$Mass), length.out = 200),
                       Species = unique(cuckoo$Species))
newdata$Beg <- predict(cuckoo_glm, newdata, type = 'response')

## explore ?predict.glm

p <- ggplot(mapping = aes(x = Mass, y = Beg, colour = Species)) +
  geom_point(data = cuckoo) +  geom_line(data = newdata) +
  mtheme_classic()




# Bacterial growth -------------------------------------------------------------
#ac <- read.csv("data/raw/valletta_bac.csv")

bac$media <- as.factor(bac$media)
bac$cabinet <- as.factor(bac$cabinet)

bac_lm <- lm(growth ~ media, data = bac)

ummary(bac_lm)


ac_lm2 <- lm(growth ~ media + cabinet, data = bac)

ummary(bac_lm2)


# Building the mixed model with cabined as a random effect#ac_lmer <- lmer(growth ~ media + (1 | cabinet), data = bac)

ummary(bac_lmer)


## -Simulating the confidence interval of the residualsfeEx <- FEsim(bac_lmer, 1000)


fe <- plotFEsim(feEx) +
  theme_bw() + labs(title = "Coefficient Plot",
                    x = "Median Effect Estimate", y = "Evaluation Rating")


fe

