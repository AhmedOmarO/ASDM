#install.packages("GGally")
library(tidyverse)
library(GGally)

vignette("GGally")
?GGally

menu <- read_csv("infomdwr/R_visualization/data/menu.csv")

# Get an idea of what the menu dataset looks like
names(menu)
glimpse(menu)

## this is where R gets tricky, 
#needed, clean the serving size based on the food type, he ended up splitting the data into 3 datasets
Transformation drinks
drink_fl <- menu |> 
  filter(str_detect(`Serving Size`, " fl oz.*")) |> 
  mutate(`Serving Size` = str_remove(`Serving Size`, " fl oz.*")) |> 
  mutate(`Serving Size` = as.numeric(`Serving Size`) * 29.5735)

drink_carton <- menu |> 
  filter(str_detect(`Serving Size`, "carton")) |> 
  mutate(`Serving Size` = str_extract(`Serving Size`, "[0-9]{2,3}")) |> 
  mutate(`Serving Size` = as.numeric(`Serving Size`))

# Transformation food
food <-  menu |> 
  filter(str_detect(`Serving Size`, "g")) |> 
  mutate(`Serving Size` = str_extract(`Serving Size`, "(?<=\\()[0-9]{2,4}")) |> 
  mutate(`Serving Size` = as.numeric(`Serving Size`))

# Add Type variable indicating whether an item is food or a drink 
menu_tidy <-  
  bind_rows(drink_fl, drink_carton, food) |> 
  mutate(
   Type = case_when(
     as.character(Category) == 'Beverages' ~ 'Drinks',
     as.character(Category) == 'Coffee & Tea' ~ 'Drinks',
     as.character(Category) == 'Smoothies & Shakes' ~ 'Drinks',
     TRUE ~ 'Food'
   )
  )


## better code 
# menu_tidy <- menu %>%
#   mutate(
#     # Clean and convert serving size
#     Serving_Size_ml = case_when(
#       str_detect(`Serving Size`, "fl oz") ~ as.numeric(str_remove(`Serving Size`, " fl oz.*")) * 29.5735,
#       str_detect(`Serving Size`, "carton") ~ as.numeric(str_extract(`Serving Size`, "[0-9]{2,3}")),
#       str_detect(`Serving Size`, "g") ~ as.numeric(str_extract(`Serving Size`, "(?<=\\()[0-9]{2,4}")),
#       TRUE ~ NA_real_
#     ),
    
#     # Add type classification
#     Type = case_when(
#       Category %in% c("Beverages", "Coffee & Tea", "Smoothies & Shakes") ~ "Drinks",
#       TRUE ~ "Food"
#     )
#   )

menu

dim(menu)

dim(menu_tidy)

ggplot(data = menu_tidy, mapping = aes(x=Category)) +
geom_bar() +
theme_minimal()


caolries_hist <- ggplot(data = menu_tidy , mapping = aes(x = Calories ))+
geom_histogram()
# 4. Plot the distribution of Calories for each Category using geom_density() in combination with facet_wrap(), can you see in which Category the outlier that can be seen in the histogram falls?
caolries_hist + facet_wrap(~Category)

# 5. Create a boxplot of the Calories for each Category. Is the outlier in the same Category as you thought it was in based on the previous question?
calories_box <- ggplot(
  data = menu_tidy , 
  mapping = aes(x = Category , y = Calories)
) + geom_boxplot()

calories_box

# 6. Create a plot using geom_col() to visualise the number of Calories of each item in the Chicken & Fish category.

menu_tidy |> 
  filter(Category == "Chicken & Fish") |> 
  ggplot(aes(x = Item, y = Calories)) +
  geom_col() +
  coord_flip() ## nice trick to flip coordinates 

#   7. Create a scatter plot to visualise the association between serving size and calories.
# Are serving size and energetic value related to each other? Did you expect this outcome? Use the alpha argument in geom_point() to adjust the transparency. NB: to deal with spaces in variable names in ggplot(), you can surround your variable by backticks, e.g., Serving Size.


menu_tidy |> 
  ggplot(aes(x = `Serving Size`, y = Calories)) +
  geom_point(alpha = 0.5) 

# 8. Create a new scatter plot to visualise the association between serving size and calories, but now use the colour argument to make a distinction between Type (see ?aes for more info).
# Use geom_smooth() to add a regression line to the plot. Does this alter your conclusion about the relationship between serving size and calories? What do you conclude now?
menu_tidy |> 
  ggplot(aes(x = `Serving Size`, y = Calories, colour = Type)) +
  geom_point() +
  geom_smooth(method = "lm")

# 10. Create a plot using ggpairs() where the association between at least 4 different variables is visualized. Are there differences in the associations between those variables based on item Type?
# In this plot, the association between `Serving Size`, 
# `Calories` and the three macro nutrients are 
# visualised. Because GGally is an extension of 
# ggplot2, additional aesthetics arguments can be 
# added to make a distinction in type.

menu_tidy |> 
  ggpairs(
    mapping = aes(colour = Type),
    columns = c("Serving Size", "Calories", "Total Fat", 
                "Carbohydrates", "Protein")
  )



## 7etta 3ala ganb, insight generator using R 
# library(dplyr)
# library(purrr)

# # Identify categorical and numerical columns
# categorical_vars <- names(menu_tidy)[sapply(menu_tidy, is.character) | sapply(menu_tidy, is.factor)]
# numerical_vars   <- names(menu_tidy)[sapply(menu_tidy, is.numeric)]

# # Generate summaries for each categorical variable
# # Create all combinations of categorical variables
# cat_combos <- purrr::map(1:length(categorical_vars), ~combn(categorical_vars, ., simplify = FALSE)) %>%
#   unlist(recursive = FALSE)

# # Build the cube
# cube <- purrr::map(cat_combos, function(grp) {
#   menu_tidy %>%
#     group_by(across(all_of(grp))) %>%
#     summarise(
#       across(all_of(numerical_vars),
#              list(
#                mean = ~mean(.x, na.rm = TRUE),
#                sum  = ~sum(.x, na.rm = TRUE)
#              ),
#              .names = "{col}_{fn}")
#     ) %>%
#     mutate(grouping = paste(grp, collapse = ", "), .before = 1)
# }) %>%
#   bind_rows()

