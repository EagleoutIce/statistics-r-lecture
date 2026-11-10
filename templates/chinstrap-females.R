# Chinstrap females
library(ggplot2)
f <- subset(penguins,
  sex == "female" &
  species != "Gentoo")
f <- droplevels(f)

# 1. plot: mean and 95 % interval

# 2. Welch t-test
