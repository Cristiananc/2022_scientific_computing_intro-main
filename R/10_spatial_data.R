#install.packages("sf")
#install.packages("tmap")
#install.packages("rnaturalearth")
#install.packages("remotes")
#remotes::install_github("ropensci/rnaturalearthhires")

library(sf)
library(tmap)
library(dplyr)
library(rnaturalearth)
library(rnaturalearthhires)
library(raster)

#Introduction to spatial data in R --------------------
#Examining an sf object
#We use the tmap package to work with sf (simple features) objects

#We load a world map
data(World)

#Package tmap has a syntax similar to ggplot. The functions start all with tm_
tm_shape(World) +
  tm_borders()

#Exploring a bit the characteristics of the World object
head(World)
names(World)
class(World)
dplyr::glimpse(World)

#Exploring plots with the World object
plot(World[1])

#In this case it's plotting only for the country Albania
plot(World[1,])

plot(World["pop_est"])

#The geometry “column” and geometries as objects ------------------
head(World[, 1:4])
World$geometry

#Geometries are a class of their own
class(World$geometry)

head(sf::st_coordinates(World))

no_geom <- sf::st_drop_geometry(World)
class(no_geom)

#bounding boxes
st_bbox(World)

#Manipulating sf objects --------------
#We can manipulate sf just like data frames, we can subset, filter and merge and so on.

#We want to plot only the countries in the South America
World %>%
  filter(continent == "South America") %>%
  tm_shape() +
  tm_borders()

#We can create new variables and use them in the map
World %>%
  mutate(our_countries = if_else(iso_a3 %in% c("COL","BRA", "MEX", "ARG"), "red", "grey")) %>%
  tm_shape() +
  tm_borders() +
  tm_fill(col = "our_countries") +
  tm_add_legend("fill",
                "Countries",
                col = "red")

#Loading, ploting, and saving a shapefile from the disk -------------------
bra <- ne_states(country = "brazil", returnclass = "sf")
plot(bra)

dir.create("data/shapefiles", recursive = TRUE)
st_write(obj = bra, dsn = "data/shapefiles/bra.shp", delete_dsn =  TRUE)


#Loading, ploting, and saving a raster from the disk ------------------
dir.create(path = "data/raster/", recursive = TRUE)
tmax_data <- getData(name = "worldclim", var = "tmax", res = 10, path = "data/raster/")
plot(tmax_data)

is(tmax_data)
dim(tmax_data)
extent(tmax_data)
res(tmax_data)

#Palettes
library(RColorBrewer)
display.brewer.all(type = "seq")
display.brewer.all(type = "div")
