# Script to manipulate data in relational data bases ---#
# part of Scientific Computing course ICTP/Serrapilheira
# original data from Jeliazkov et al 2020 Sci Data
# (https://doi.org/10.1038/s41597-019-0344-7)
# first version 2022-07-12
#-----------------------------------------------------------#

# loading needed packages
library(tidyverse)
library(reshape2)


# Reading the data in R ----

# The files are all in .csv format, separated by commas. So let's use the `read.csv()` function. We could also use `read.table()` with the arguments `sep = ","` and `header = TRUE`
# So let's read the five sets of data. A very useful function for reading data is the `list.files()` from the **base** package. This function lists files in a directory, based on a pattern.

# We will apply the function to list all files in the directory `data` with the extension `.csv`.
files_path <- list.files(path = "data/raw/cestes",
                         pattern = ".csv",
                         full.names = TRUE)

files_path

# The `files_path` object is a vector of five elements (after all, there are five files) containing the full name of the file. Let's use the contents of this vector in the `read.csv()` function. We will use the a loop to read all data at once.
file_names <- gsub(".csv", "", basename(files_path), fixed = TRUE)
for (i in 1:length(files_path)) {
  data <- read.csv(files_path[[i]])
  assign(file_names[i], data)
}


# Let's apply the `head()`, `dim()` and `summary()` functions to inspect all files. Try to understand based on the output and the help page (e.g.: `?head`) what each of the functions returns.

# Understanding the object `comm`
head(comm)
dim(comm)
summary(comm)

# Understanding the object `coord`
head(coord)
dim(coord)
summary(coord)

# Understanding the object `envir`
head(envir)
dim(envir)
summary(envir)

# Understanding the object `splist`
head(splist)
dim(splist)
summary(splist)

# Understanding the object `traits`
head(traits)
dim(traits)
summary(traits)

# Data summary

# How many species in the dataset? We can simply count the number of rows in `splist`.
nrow(splist)

# How many areas sampled? We can count the number of lines of `comm` or `envir` objects.
nrow(comm)
nrow(envir)

# How many environmental variables?
# all variables except for the first column with the id
names(envir)[-1]
# counting the variables
length(names(envir)[-1])

# Joining different tables through common identifiers ----

# Let's use the `merge()` function from the __base__ package to add the coordinate column to the object containing the environmental variables. This function will combine two worksheets through a common identifier, which is the primary key. In the case of the `envir` object, the primary key is the `Sites` column that contains the number of the sampled locations. We can call this column using the `$` operator.
envir$Sites

# There are 97 areas. Let's see what happens when we use the `summary()` function.
summary(envir$Sites)

# Transforming variable types

# In R, the `Sites` column that represents a categorical variable with the id of each area is being understood as a numeric variable. Let's convert this column to a factor, this way it will better represent the meaning of the variable which is simply the id of each area. For this we use the `factor()` function

# if we get the class of this vector, we will see that it is numeric
class(envir$Sites)
# we want it to be a categorical variable. For this, we convert into a factor
as.factor(envir$Sites)
# if we just use as.factor, we don't do the conversion, let's do an assignment
envir$Sites <- as.factor(envir$Sites)

# Let's do the same for the `Sites` variable of the `coord` object.
coord$Sites <- as.factor(coord$Sites)

# Joining `coord` and `envir`

# Let's then apply the `merge` function.
envir_coord <- merge(x = envir,
                     y = coord,
                     by = "Sites")

# We can check the join with the `dim()` and `head()` functions. How many columns should we have at the end? What columns were added?
dim(envir)
dim(coord)
dim(envir_coord)
head(envir_coord)

# Transforming a species matrix vs. area in a data table

# Now, we want to transform our species vs. area on a worksheet that contains each __observation__ in a __row__ and each __variable__ in a __column__. Each observation is the abundance of a species in a given area. To do this transformation we will use the `gather()` function from the __tidyr__ package. As we have 97 sites and 56 species, we will end up with an object with 5432 lines (97 x 56).

# vector containing all sites
Sites <- envir$Sites
length(Sites)

# vector with the name of species
n_sp <- nrow(splist)
n_sp

# creating table with each species in each area species in rows
comm_df <- tidyr::pivot_longer(comm, cols = 2:ncol(comm), names_to = "TaxCode", values_to = "Abundance")

# Let's check the object's header and dimensions.
dim(comm_df)
head(comm_df)

# Adding all variables to `comm_df`

# Finally, let's add `splist`, `traits` and `envir_coord` to the `comm_df` worksheet.

# As we saw in the class, the relationships between two tables are always made pairwise. So, let's merge the tables together using the `merge()` function.

# Table `comm_df` and `splist`

# First, let's add the species information contained in `splist` to `comm_df` using the `TaxCode` column.
comm_sp <- merge(comm_df, splist, by = "TaxCode")
head(comm_sp)
# same as: dplyr::left_join(comm_df, splist, by = "TaxCode)

# Table `comm_sp` and `traits`

# Second, we added the species attribute data to the community table. In the `traits` table, the column that identifies the species is called `Sp`. Before doing the join, we need to change the name to match the name of the column in `comm_sp` which is `TaxCode`.
names(traits)
# renaming the first element
colnames(traits)[1] <- "TaxCode"

comm_traits <- merge(comm_sp, traits, by = "TaxCode")
head(comm_traits)

# Table `comm_traits` and `envir_coord`

# We are almost in the end, we will now bind the environmental data (already containing the coordinates) to the community table using the column `Sites`.

comm_total <- merge(comm_traits, envir_coord, by = "Sites")
head(comm_total)

if (!dir.exists("data/processed")) dir.create("data/processed")

# Finally, we end our script writing the modified table. We will use the function `write.csv()`.
write.csv(x = comm_total,
          file = "data/processed/03_Pavoine_full_table.csv",
          row.names = FALSE)

# Extra: filter ----------------------------------------------------------------
sp1 <- filter(comm_total, TaxCode == "sp1", Elev > 3)

View(sp1)
