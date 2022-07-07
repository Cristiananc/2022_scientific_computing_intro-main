# Scientific programming course ICTP-Serrapilheira July-2022
# Class #01: Introduction to R
# Introdutory script to play with R data types

# See where you are working at
getwd()

# Exploring R ------------------------------------------------------------------
sqrt(10)
round(3.14159)
args(round)
?round

print("Hi!")
print("Hello, world!")


## ----datatypes----------------------------------------------------------------
animals  <- c("mouse", "rat", "dog", "cat")
weight_g <- c(50, 60, 65, 82)


## ----class1-------------------------------------------------------------------
class(animals)


## ----class2-------------------------------------------------------------------
class(weight_g)


## ---- vectors-----------------------------------------------------------------
animals
animals[2]


## ----subset-------------------------------------------------------------------
animals[c(3, 2)]


## ----subset-logical-----------------------------------------------------------
weight_g <- c(21, 34, 39, 54)
weight_g[c(TRUE, FALSE, FALSE, TRUE)]
weight_g[weight_g > 35]


## ----recycling----------------------------------------------------------------
more_animals <- c("rat", "cat", "dog", "duck", "goat")
animals %in% more_animals

## subset with grep ------------------------------------------------------------
more_animals[grepl("^d", more_animals)]
more_animals[grep("^d", more_animals)]

## ----recycling2---------------------------------------------------------------
animals
more_animals
animals == more_animals
setdiff(animals, more_animals)

## ----na-----------------------------------------------------------------------
heights <- c(2, 4, 4, NA, 6)
mean(heights)
max(heights)
mean(heights, na.rm = TRUE)
max(heights, na.rm = TRUE)

# Data structures --------------------------------------------------------------

# Factor
animals
animals_cls <- factor(c("small", "medium", "medium", "large"))
levels(animals_cls)
levels(animals_cls) <- c("small", "medium", "large")
animals_cls

# Matrices
set.seed(42)
matrix(runif(20), ncol = 2)

matrix(nrow = 4, ncol = 3)

nums <- 1:12

matrix(data = nums, nrow = 3)

matrix(data = nums, nrow = 3, byrow = T)

names_matrix <- list(c("row1", "row2", "row3"),
                     c("col1", "col2", "col3", "col4"))
names_matrix

matrix(data = nums, nrow = 3, byrow = T, dimnames = names_matrix)

m <- matrix(data = nums, nrow = 3, byrow = T, dimnames = names_matrix)

dim(m)
dimnames(m)

df <- data.frame(m)
class(df)
class(m)


# Data frames
animals_df <- data.frame(name = animals,
                         weight = weight_g,
                         weight_class = animals_cls)

animals_df[2, 1]
animals_df[animals_df$weight_class == "medium", ]
animals_df[animals_df$weight_class == "medium", "weight"]

# List
animals_list <- list(animals_df, animals)
animals_list[[1]]

# Importing data ---------------------------------------------------------------

# Reading data using read.csv
surveys <- read.csv(file = "./data/raw/portal_data_joined.csv")

head(surveys)

# Reading data using read.table
surveys_check <- read.table(
  file = "./data/raw/portal_data_joined.csv",
  sep = ",",
  header = TRUE)
head(surveys_check)

# Checking if both files are equal
all(surveys == surveys_check)

# inspecting
str(surveys) #structure
dim(surveys)
nrow(surveys)
ncol(surveys)

head(surveys)
tail(surveys)

names(surveys)
rownames(surveys)
length(surveys)

sub <- surveys[1:10, ]
sub[1, 1]
sub[1, 6]
sub[["record_id"]]
sub$record_id

sub[1:3, 7]

sub[3, ]

# [row, columns]

surveys[ , 6]
surveys[1, ]
surveys[4, 13]

surveys[1:4, 1:3]

surveys[, -1]
nrow(surveys)
surveys[-(7:34786), ]
head(surveys)
surveys[-(7:nrow(surveys)), ]

surveys["species_id"]
surveys[["species_id"]]

da <- surveys["species_id"]

surveys[ ,"species_id"]
surveys$species_id

##
sub <- surveys[1:10,]
str(sub)

sub$hindfoot_length

sub$hindfoot_length == NA

is.na(sub$hindfoot_length)
!is.na(sub$hindfoot_length)

sub$hindfoot[!is.na(sub$hindfoot_length)]

mean(sub$hindfoot_length)
mean(sub$hindfoot_length, na.rm = T)

non_NA_w <- surveys[!is.na(surveys$weight),]
dim(non_NA_w)
dim(surveys)


non_NA <- surveys[!is.na(surveys$weight) &
                    !is.na(surveys$hindfoot_length), ]
dim(non_NA)

complete.cases(surveys)

surveys1 <- surveys[complete.cases(surveys) , ]
dim(surveys1)

surveys2 <- na.omit(surveys)
dim(surveys2)

if (!dir.exists("data/processed")) dir.create("data/processed")
write.csv(surveys1, "data/processed/01_surveys_mod.csv")
