library(tidyverse)
# Create a tibble (modern data frame)

# x <- 

tibble(
  x = 1:3, 
  y = c("a", "b", "c")
) | unite(x, x, y, col = "year", sep = "") 

mtcars |>
 group_by(cyl) |>
 summarize(avg = mean(mpg))
