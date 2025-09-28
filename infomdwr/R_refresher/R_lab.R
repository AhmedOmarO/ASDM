library(tidyverse)
menu <- read_csv('infomdwr/R_refresher/menu.csv')
# Get an idea of what the menu dataset looks like
head(menu)
glimpse(menu)
names(menu)
menu$'Serving Size'

menu$`Serving Size`
menu$`Serving Size` <- as.factor(menu$`Serving Size`)