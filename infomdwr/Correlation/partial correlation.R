# Load packages
library(dplyr)
library(GGally)
library(ggplot2)

set.seed(42)

# Step 1: Generate correlated data
n <- 100
C <- rnorm(n, mean = 50, sd = 10)
A <- 0.6 * C + rnorm(n, sd = 5)
B <- 0.5 * C + rnorm(n, sd = 5)

# Check simple correlations
cor(A, B)
cor(A, C)
cor(B, C)

tb = tibble(A,B,C)

ggpairs(tb)
resid_A <- lm(A ~ C)$residuals
resid_B <- lm(B ~ C)$residuals

resid_df <- data.frame(resid_A, resid_B)

ggpairs(resid_df) +
  ggtitle("Partial correlation: A and B (controlling for C)")
