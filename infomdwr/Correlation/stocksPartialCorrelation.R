# ==========================
# 📈 Partial Correlation of Stocks (Market-Adjusted)
# ==========================

# Install needed packages (run once)
install.packages(c("quantmod", "ppcor", "dplyr", "GGally"))

# Load libraries
library(quantmod)
library(ppcor)
library(dplyr)
library(GGally)

# --------------------------
# 1. Download stock data
# --------------------------
symbols <- c("AAPL", "MSFT", "GOOG", "OXY", "META", "SPUS")  # ^GSPC = S&P 500 index
getSymbols(symbols, src = "yahoo", from = "2023-01-01", to = Sys.Date(), auto.assign = TRUE)

# --------------------------
# 2. Prepare daily log returns
# --------------------------
prices <- do.call(merge, lapply(symbols, function(x) Ad(get(x))))
colnames(prices) <- symbols
returns <- na.omit(diff(log(prices)))

# --------------------------
# 3. Simple correlation between stocks
# --------------------------
stock_returns <- returns[, symbols[symbols != "SPUS"]]
cor_simple <- cor(stock_returns)
print(round(cor_simple, 2))

# --------------------------
# 4. Partial correlation controlling for market
# --------------------------
market <- returns$`SPUS`
residuals_df <- as.data.frame(lapply(stock_returns, function(x) lm(x ~ market)$residuals))

# Compute partial correlation matrix among residuals
partial_cor <- cor(residuals_df)
print(round(partial_cor, 2))

# --------------------------
# 5. Visualize correlations
# --------------------------

## (a) Raw correlations
GGally::ggpairs(stock_returns,
                upper = list(continuous = wrap("cor", size = 3)),
                title = "Raw correlations between stock returns")

## (b) Market-adjusted (partial) correlations
GGally::ggpairs(residuals_df,
                upper = list(continuous = wrap("cor", size = 3)),
                title = "Partial correlations between stocks (controlling for S&P 500)")

# --------------------------
# 6. Optional: Compare distributions visually
# --------------------------
library(ggplot2)
residuals_df |>
  tidyr::pivot_longer(cols = everything(), names_to = "Stock", values_to = "Residual") |>
  ggplot(aes(x = Residual, fill = Stock)) +
  geom_density(alpha = 0.4) +
  theme_minimal() +
  labs(title = "Distribution of Market-Adjusted Returns (Residuals)",
       x = "Residual Return", y = "Density")
