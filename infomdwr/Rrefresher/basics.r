# R.home("bin")
## install necessary packages
# install.packages("tidyverse")
# install.packages("ggplot")
# install.packages("dplyr")
# install.packages("palmerpenguins")

# install.packages("data.table")
# Install devtools if you don't have it
# install.packages("devtools")

# Install httpgd from GitHub (CRAN removed it Apr 2025)
# devtools::install_github("nx10/httpgd")

# Install languageserver (needed for VS Code R LSP)
# install.packages("languageserver")

# Define a simple function in R
my_function <- function(x, y) {
    # This function takes two arguments and returns their sum
    result <- x + y
    return(result)
}

# Example usage
output <- my_function(5, 3)
print(output)  # Output: 8

library(data.table) 

n = 100 

dt = data.table(
    a = sample(letters[1:5], n, replace=TRUE),
    b = rnorm(n),
    c = sample(1:10, n, replace=TRUE)
)


# Display the first few rows of the data table
print(head(dt))

y <- 10
f <- function(x) {
  x + y
}

f(10)


# working with vectors
a<-c(1.1539613, -0.3511877,  0.6704161, -0.4547493,  0.7816482 ,-1.4728369,
  1.7557698 ,-1.4971543 , 0.3650022 ,0.9538584)

print(mean(a))

## Plot Dataframe 
df <- data.frame(x = 1:10, y = rnorm(10))
print(df)
plot(df$x, df$y)


??tidyverse
names(iris)
?names

names(ChickWeight)

# plot(df$x, df$y)
plot(ChickWeight$Time, ChickWeight$weight)

names(euro)

library(palmerpenguins)

library(ggplot2)


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))


ggplot(data = penguins)

ggplot(
  data = penguins,
  mapping = aes(x = flipper_len, y = body_mass)
) +
  geom_point()

