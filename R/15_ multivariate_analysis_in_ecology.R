library(vegan)
data(dune)
data(dune.env)
table(dune.env$Management)

#Cluster analysis of the dune vegetation
#We calculate two dissimilarity indices between sites
#Bray-Curtis distance and Chord distance


bray_distance <- vegdist(dune)
#Chord distance, euclidean distance normalized to 1
chord_distance <- dist(decostand(dune, "norm"))

library(cluster)
b_cluster  <- hclust(bray_distance, method = "average")
c_cluster <- hclust(chord_distance, method = "average")

par(mfrow = c(1,2))
plot(b_cluster)
plot(c_cluster)

is(chord_distance)
norm <- decostand(dune, "norm")
pca <- rda(norm)

plot(pca)
summary(pca)
eigen(pca)
dim(dune)

names(dune.env)
pca_env <- rda(dune.env[, c("A1", "Moisture", "Manure")])

