comm <- read.csv("data/raw/cestes/comm.csv")
traits <- read.csv("data/raw/cestes/traits.csv")

head(comm)[,1:6]
head(traits)[,1:6]

#We can add rownames instead of having columns:
rownames(comm)[1:6]
rownames(comm) <- paste0("Site", comm[,1])
comm <- comm[, -1]
head(comm)[, 1:6]

#Transforming column trait$Sp into the rownames of the dataframe
traits$Sp[1:6]
rownames(traits) <- traits$Sp
traits <- traits[,-1]
head(traits)[,1:6]

#Species richness -----------------
#Species richness can be calculated with the vegan package
library(vegan)
richness <- vegan::specnumber(comm)

#Taxonomic diversity --------------
shannon <- vegan::diversity(comm, index = "simpson")
simpson <- vegan::diversity(comm, index = "simpson")

#Functional diversity
#Taxonomic diversity indices are based on the assumption that
#species belong to one species or the other
library(cluster)
library(FD)

#Remember that implementations in the R vary
gow <- cluster::daisy(traits, metric = "gower")
gow2 <- FD::gowdis(traits)
identical(gow, gow2)

class(gow)
class(gow2)

plot(gow, gow2, asp = 1)

#Raos's quadratic entropy calculation in R

install.packages("SYNCSA")
library(SYNCSA)

tax <- rao.diversity(comm)
fun <- rao.diversity(comm, traits = traits)

splist <- read.csv("data/raw/cestes/splist.csv")

#How to extract a family
library(taxize)
classification_data <- classification(splist$TaxonName, db = "ncbi")
str(classification)
length(classification_data)

classification_data$'Arisarum vulgare'
classification_data[[1]]
classification_data[[4]]

library(dplyr)
tible_ex <- classification_data[[1]] %>%
  filter(rank == "family") %>%
  select(name)

extract_family <- function(x){
  if(!is.null(dim(x))) {
  y <- x %>%
    filter(rank == "family") %>%
    select(name) #returns a data.frame
  return(y)
  }
}

families <- list()
for (i in 1:length(classification_data)) {
  families[[i]] <- extract_family(classification_data[[i]])
}

library(ape)
library(phytools)
