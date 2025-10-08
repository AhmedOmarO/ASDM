## install.packages("ISLR")

# install.packages("ISLR")


library(ISLR)
library(tidyverse)


?Hitters # help (Hitters)
head(Hitters)
glimpse(Hitters)

## plots without ggplot2
# scatterplot of Salary vs Years
plot(Hitters$Years, Hitters$Salary, xlab = "Years in MLB", ylab = "Salary in thousands of dollars")

# histogram of the distribution of salary
hist(Hitters$Salary, xlab = "Salary in thousands of dollars")


## plots with ggplot2
# scatterplot of Salary vs Years
ggplot(Hitters, aes(x = Years, y = Salary)) +
    geom_point() +
    labs(x = "Years in MLB", y = "Salary in thousands of dollars")  


# histogram of the distribution of salary
ggplot(Hitters, aes(x = Salary)) +
    geom_histogram(binwidth = 100, fill = "blue", color = "black") 


homeruns_plot <- 
  ggplot(Hitters, aes(x = Hits, y = HmRun)) +
  geom_point() +
  labs(x = "Hits", y = "Home runs")

 
 
homeruns_plot + geom_density2d()

homeruns_plot + geom_density2d() +theme_minimal()


## Aesthetics and data preparation

set.seed(1234)
student_grade  <- rnorm(32, 7)
student_number <- round(runif(32) * 2e6 + 5e6)
programme      <- sample(c("Science", "Social Science"), 32, replace = TRUE)

tibble_students <- tibble(student_grade, student_number, programme) 
gg_students <- tibble(
    number = as.character(student_number),
    grade = as.double(student_grade),
    programme = factor(programme)) # categories should be factors.

setdiff(names(tibble_students), names(gg_students)) ## check if the column names are the same

## change the column names 
names(tibble_students) <- c("grade", "number", "programme")

## check again
setdiff(names(tibble_students), names(gg_students))

sapply(tibble_students, class)
sapply(gg_students, class)

## change the column types
tibble_students <- tibble_students %>%
    mutate(
        number = as.character(number),
        programme = factor(programme)
    )   

## Swap the axis for the homeruns plot
###If you use plotly, coord_flip() is not supported.
###Instead, swap the variables manually in aes() before calling ggplotly().


    ggplot(Hitters, aes(x = HmRun, y = Hits,)) +
    geom_point() +
    labs(x = "Home runs", y = "Hits")
# 4. Recreate the same plot once more, but now also map 
# the variable League to the colour aesthetic and the variable Salary
#  to the size aesthetic.

    ggplot(Hitters, aes(x = HmRun, y = Hits, color = League, size = Salary)) +
    geom_point() +
    labs(x = "Home runs", y = "Hits")

ggplot(
  data = Hitters,
  mapping = aes(x = HmRun, y = Hits, colour = League, size = Salary)) +
  geom_point()

ggplot(
  data = Hitters,
  mapping = aes(x = HmRun, y = Hits, color = League, size = Salary)) +
  geom_point()


## Geoms
## https://ggplot2.tidyverse.org/reference/#section-layer-geoms
# There are two types of geoms:
# geoms which perform a transformation of the data beforehand, such as geom_density_2d() which calculates contour lines from x and y positions.
# geoms which do not transform data beforehand, but use the aesthetic mapping directly, such as geom_point().


# Histogram
#Use geom_histogram() to create a histogram of the grades of the students in the gg_students dataset.
ggplot(gg_students, aes(x = grade)) +
  geom_histogram(binwidth = 1) +
  theme_minimal() +
  labs(x = "Grade")

# Density

ggplot(gg_students, aes(x = grade)) +
  geom_density(fill = "light seagreen", alpha = 0.5) +
  theme_minimal() +
  labs(x = "Grade")


# 8. Add rug marks to the density plot through geom_rug(). You can edit the colour and size of the rug marks using those arguments within the geom_rug() function.
ggplot(gg_students, aes(x = grade)) +
  geom_density(fill = "light seagreen", alpha = 0.5) +
  geom_rug(color = "blue", size = 1) +
  theme_minimal() +
  labs(x = "Grade")


# 9. Increase the data to ink ratio by removing the y axis label, setting the theme to theme_minimal(), and removing the border of the density polygon.
ggplot(gg_students, aes(x = grade)) +
  geom_density(fill = "light seagreen", alpha = 0.5,color = NA) +
  geom_rug(color = "light seagreen", size = 1) +
  theme_minimal() +
  labs(x = "Grade", y = NULL )+
  xlim(0, 10)

## Boxplot
# 10. Create a boxplot of the grades of the students in the gg_students dataset

ggplot(gg_students, aes(x = programme, y = grade)) +
  geom_boxplot(fill = "lightseagreen", alpha = 0.5) +
  theme_minimal() +
  labs(x = "Programme", y = "Grade")


## Barplot
#12. Create a bar plot of the variable Years from the Hitters dataset.
#remotes::install_github("vankesteren/firatheme")
library(firatheme)


ggplot(Hitters, mapping = aes(x=Years)) + geom_bar() + theme_fira()

ggplot(mtcars, aes(x = mpg*0.43, y = wt*0.4535924, colour = factor(cyl))) +
       geom_point(size = 2) + geom_smooth(se = FALSE) +
       labs(title = "Car weight vs efficiency",
            x = "Efficiency (km/l)",
            y = "Weight (1000 kg)",
            colour = "Cylinders") +
            theme_minimal()
# Faceting
# 13. Create a data frame called baseball based on the Hitters dataset.
# In this data frame, create a factor variable which splits players’ salary range into 3 categories. 
#Tip: use the filter() function to remove the missing values, and then use the cut() function and assign nice labels to the categories. 
#In addition, create a variable which indicates the proportion of career hits that was a home run.

  baseball <- Hitters |> 
  filter(!is.na(Salary)) |> 
  mutate(
    Salary_range = cut(Salary, breaks = 3, 
                       labels = c("Low salary", "Mid salary", "High salary")),
    Career_hmrun_proportion = CHmRun/CHits
  )

# 14. Create a scatter plot where you map CWalks to the x position and the proportion you calculated in the previous exercise to the y position.
# Fix the y axis limits to (0, 0.4) and the x axis to (0, 1600) using ylim() and xlim(). Add nice x and y axis titles using the labs() function. Save the plot as the variable baseball_plot.

baseball_plot <-   
  baseball |> 
  ggplot(aes(x = CWalks, y = Career_hmrun_proportion)) +
  geom_point() +
  ylim(0, 0.4) +
  xlim(0, 1600) + 
  theme_minimal() +
  labs(y = "Proportion of home runs",
       x = "Career number of walks")

baseball_plot

# 15. Split up this plot into three parts based on the salary range variable you calculated. Use the facet_wrap() function for this; look at the examples in the help file for tips.

baseball_plot + facet_wrap(~Salary_range)
