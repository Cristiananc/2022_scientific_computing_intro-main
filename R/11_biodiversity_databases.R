#This script refers to the class about biodiversity databases in July 27, 2022

#Packages needed for the class
install.packages("rgbif")
install.packages("Taxonstand")
install.packages("CoordinateCleaner")
install.packages("maps")

library(rgbif)
library(Taxonstand)
library(CoordinateCleaner)
library(maps)

# 1. Getting the data -------------------
species <- "Myrsine coriacea"
myrsine_occ <- occ_search(scientificName = species,
                           limit = 100000)

names(myrsine_occ)
myrsine.data <- myrsine_occ$data
colnames(myrsine.data)

#Exporting the raw data
write.csv(myrsine.data,
          "data/raw/myrsine_data.csv",
          row.names = FALSE)


# 2. Checking species taxonomy ----------------

#Here we check for the entries for the species name we are working with
#We can see that this species in particular has a long history of synonyms.
species.names <- sort(unique(myrsine.data$scientificName))

#We have a column showing the currently accepted taxonomy
table(myrsine.data$taxonomicStatus)

#We can see which names are accepted or not
table(myrsine.data$scientificName, myrsine.data$taxonomicStatus)

#It checks if the taxonomic updates are correct
tax.check <- TPL(species.names)

# creating new object w/ original and new names after TPL
new.tax <- data.frame(scientificName = species.names,
                      genus.new.TPL = tax.check$New.Genus,
                      species.new.TPL = tax.check$New.Species,
                      status.TPL = tax.check$Taxonomic.status,
                      scientificName.new.TPL = paste(tax.check$New.Genus,
                                                     tax.check$New.Species))
# now we are merging raw data and checked data
myrsine.new.tax <- merge(myrsine.data, new.tax, by = "scientificName")

#Exporting the data after taxonomy check
write.csv(myrsine.new.tax,
          "data/processed/data_taxonomy_check.csv",
          row.names = FALSE)


#3. Checking species’ coordinates ------------------
plot(decimalLatitude ~ decimalLongitude, data = myrsine.data, asp = 1)
#Adding the map on top of the coordinates
map(, , , add = TRUE)


#Exporting the data after coordinate check


#Homework: do a map like these from the tutorial but on tmap


