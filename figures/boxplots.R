source("figures/theme.R")

set.seed(42)
n <- 300
groups <- tibble(
  group = rep(c("A", "B", "C"), each = n),
  value = c(
    rnorm(n, 0, 1),
    sample(c(rnorm(n / 2, -1.2, 0.35), rnorm(n / 2, 1.2, 0.35))),
    runif(n, -1.7, 1.7)
  )
) |>
  mutate(value = approx(quantile(value, 0:4 / 4), c(-2, -1, 0, 1, 2), value)$y, .by = group)

fill <- lecture_colours[["green"]]

base <- ggplot(groups, aes(group, value)) +
  labs(x = NULL, y = "Standardized value") +
  theme(legend.position = "none")

steps <- list(
  base + geom_boxplot(fill = fill, coef = Inf, width = 0.6),
  base +
    geom_boxplot(fill = fill, alpha = 0.25, coef = Inf, width = 0.6, outlier.shape = NA) +
    geom_jitter(width = 0.2, alpha = 0.6, size = 0.6, color = lecture_colours[["blue"]]),
  base +
    geom_violin(fill = fill, color = NA, alpha = 0.6, adjust = 0.5) +
    geom_boxplot(width = 0.12, fill = "white", coef = Inf, linewidth = 0.3)
)
for (i in seq_along(steps)) save_figure(steps[[i]], paste0("box-hides-", i), 3, 2, shown = 5)
