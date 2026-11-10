source("figures/theme.R")

long <- anscombe |>
  mutate(row = row_number()) |>
  pivot_longer(-row, names_to = c(".value", "set"), names_pattern = "(x|y)([0-9])") |>
  select(set, x, y)

export_csv(long, "anscombe")

stats <- long |>
  summarize(
    mean_x = mean(x), mean_y = mean(y), var_x = var(x), var_y = var(y),
    cor = cor(x, y),
    intercept = coef(lm(y ~ x))[[1]], slope = coef(lm(y ~ x))[[2]],
    .by = set
  ) |>
  mutate(across(-set, \(v) round(v, 2)))

export_csv(stats, "anscombe-stats")
print(stats)
