## Read dataset
library(tidyverse)

## load rds file
md <- readRDS("infomdwr/MissingData/income.rds")

## Plot income distribution
ggplot(md, aes(x = income)) +
    geom_density()+
    labs(title = "Income Distribution", x = "Income", y = "Frequency") +
    theme_minimal()

## Identify missing data
missing_summary <- md %>%
    summarise(across(everything(), ~ sum(is.na(.)), .names = "missing_{col}")) %>%
    pivot_longer(everything(), names_to = "variable", values_to = "missing_count")  


## Generate Missing Values

prob_mis <- function(psi0, psi1, psi2, psi3, age, gender, income) {
  exp(psi0 + psi1 * age + psi2 * (gender == "Male") + psi3 * income) /
    (1 + exp(psi0 + psi1 * age + psi2 * (gender == "Male") + psi3 * income))
}


# Not Data-Dependent (NDD)

## 1. Use the function above to add a variable with the missingness probabilities misprob_ndd to the income data, in which you specify all missingness parameters to be 0 (i.e., = 0), such that the probability of having a missing value equals for everyone. Tip: use the mutate() function to create the new variable.
md <- md %>%
    mutate(misprob_ndd = prob_mis(0, 0, 0, 0, age, gender, income))
md
## 2. Use rbinom() to create a missingness indicator R_ndd using the misprob_ndd probabilities, and add this indicator to the income data. NB: The function prob_mis gives the probability of having a missing, while the missingness indicator must give zero if income is not observed, so use 1 - rbinom() to create a proper missingness indicator.

set.seed(123) # for reproducibility
md <- md %>%
    mutate(R_ndd = 1 - rbinom(n(), 1, misprob_ndd))

## 3. Use the function ifelse() to add a new variable income_ndd to the income data, that equals NA if R_ndd equals 0, and the observed income value otherwise.

md <- md %>%
    mutate(income_ndd = ifelse(R_ndd == 0, NA, income))


ggplot(md) +
    geom_density(aes(x = income_ndd))+
    geom_density(aes(x = income))+
    geom_rug(aes(x = income_ndd), sides = "b", alpha = 0.5)+
    geom_rug(aes(x = income), sides = "b", alpha = 0.1, color = "blue")+

    labs(title = "Income Distribution", x = "Income", y = "Frequency") +
    theme_minimal()
# Seen Data-Dependent (SDD)
## 4. Use the function above to add a variable with the missingness probabilities misprob_sdd to the income data, in which you specify the missingness parameters to be , such that the probability of having a missing value depends on age
md <- md %>%
    mutate(misprob_sdd = prob_mis(-3, 0.05, 0.5, 0, age  , gender, income))

## 5. Use rbinom() to create a missingness indicator R_sdd using the misprob_sdd probabilities, and add this indicator to the income data.
set.seed(123) # for reproducibility
md <- md %>%
    mutate(R_sdd = 1 - rbinom(n(), 1, misprob_sdd))

## 6. Use the function ifelse() to add a new variable income_sdd to the income data, that equals NA if R_sdd equals 0, and the observed income value otherwise.
md <- md %>%
    mutate(income_sdd = ifelse(R_sdd == 0, NA, income))


# Unseen Data-Dependent (UDD)

## 7. Use the function above to add a variable with the missingness probabilities misprob_udd to the income data, in which you specify the missingness parameters to be  , such that the probability of having a missing value depends on age and income.
#psi0 = -7, psi1 = 0, psi2 = 0 and psi3 = 0.003
md <- md %>%
    mutate(misprob_udd = prob_mis(-7, 0, 0, 0.003, age, gender, income))   

## 8. Use rbinom() to create a missingness indicator R_udd using the misprob_udd probabilities, and add this indicator to the income data.
set.seed(123) # for reproducibility
md <- md %>%
    mutate(R_udd = 1 - rbinom(n(), 1, misprob_udd))
## 9. Use the function ifelse() to add a new variable income_udd to the income data, that equals NA if R_udd equals 0, and the observed income value otherwise.
md <- md %>%
    mutate(income_udd = ifelse(R_udd == 0, NA, income)) 


## 9. Create a plot that shows how the probability of having a missing value misprob_udd (on the y-axis) depends on income (on the x-axis).
#Note: In practice, we would never be able to do this, because we would not have the actual incomes for those who refuse to provide their income values.
ggplot(md, aes(x = income, y = misprob_udd)) +
    geom_point(alpha = 0.5) +
    # geom_smooth(method = "loess", color = "blue") +
    labs(title = "Missingness Probability vs Income", x = "Income", y = "Probability of Missingness") +
    theme_minimal()

# Visualizing missing data
## 11. Create a boxplot of the observed values and missing values of income under each of the three missing data models. What do you notice?

md_long <- md %>%
    select(income, income_ndd, income_sdd, income_udd) %>%
    pivot_longer(cols = starts_with("income"), names_to = "type", values_to = "value")

ggplot(md_long, aes(x = type, y = value)) +
    geom_boxplot() +
    geom_jitter(width = 0.2, alpha = 0.3) +
    labs(title = "Boxplot of Income under Different Missing Data Mechanisms", x = "
            Type", y = "Income") +
    theme_minimal()
