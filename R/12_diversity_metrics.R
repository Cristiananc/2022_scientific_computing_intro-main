comm <- read.csv("data/raw/cestes/comm.csv")
dim(comm)

#Species abundance, frequency and richness --------------
#1 - Which are the 5 most abundant species overall in the dataset?
abundance <- colSums(comm[,-1])
abundance_sorted <- sort(abundance, decreasing = TRUE)
five_most_abundant <- head(abundance_sorted)

# 2- How many species are there in each plot(site)? (Richness)
#Change the abundance matrix assigning 0 or 1 for presence or absence of a species
comm_aux <- comm
comm_aux[,-1][comm_aux[,-1] > 0] = 1
richness <- rowSums(comm_aux[,-1])
sites_name <- as.factor(seq(1,97))
richness_df <- data.frame(sites_name, richness)
head(richness_df)

# 3 - Which the species that is most abundant in each plot?
species_most_abundant <- apply(comm[,-1], 1, which.max)
abundance_per_site_df <- data.frame(sites_name, species_most_abundant)
head(abundance_per_site_df)
