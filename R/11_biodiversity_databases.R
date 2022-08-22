#This script refers to the class about biodiversity databases in July 27, 2022

#Packages needed for the class
#install.packages("rgbif")
#install.packages("Taxonstand")
#install.packages("CoordinateCleaner")
#install.packages("maps")

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

#Now we are going to check for coordinates. The function
#clean_coordinates() check common errors for coordinates, such as
#sea coordinates, centroids, etc
myrsine.coord <- myrsine.data[!is.na(myrsine.data$decimalLatitude)
                              & !is.na(myrsine.data$decimalLongitude),]

geo.clean <- clean_coordinates(x = myrsine.coord,
                               lon = "decimalLongitude",
                               lat = "decimalLatitude",
                               species = "species",
                               value = "clean")


#Plotting the clean data
par(mfrow = c(1, 2))
plot(decimalLatitude ~ decimalLongitude, data = myrsine.data, asp = 1)
map(, , , add = TRUE)
plot(decimalLatitude ~ decimalLongitude, data = geo.clean, asp = 1)
map(, , , add = TRUE)
par(mfrow = c(1, 1))

myrsine.new.geo <- clean_coordinates(x = myrsine.coord,
                                     lon = "decimalLongitude",
                                     lat = "decimalLatitude",
                                     species = "species",
                                     value = "spatialvalid")

tail(names(myrsine.new.geo))

#Merging the raw data with the cleaned data
myrsine.new.geo2 <- merge(myrsine.data, myrsine.new.geo,
                          all.x = TRUE)

plot(decimalLatitude ~ decimalLongitude, data = myrsine.new.geo2, asp = 1,
     col = if_else(myrsine.new.geo2$.summary, "green", "red"))
map(, , , add = TRUE)

#Exporting the data after coordinate check --------
write.csv(myrsine.new.geo2,
          "data/processed/myrsine_coordinate_check.csv",
          row.names = FALSE)

#Save the dataset as shapefile -------------
library(tmap)
library(sf)
myrsine.final <-left_join(myrsine.coord, myrsine.new.geo2)
nrow(myrsine.final)

myrsine_sf <- st_as_sf(myrsine.final, coords = c("decimalLongitude", "decimalLatitude"))
st_crs(myrsine_sf)


#Homework: do a map like these from the tutorial but on tmap


