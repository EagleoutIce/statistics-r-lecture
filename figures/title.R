source("figures/theme.R")

d <- penguins |> drop_na(bill_len, bill_dep, body_mass)

d |>
  select(species, bill_len, bill_dep) |>
  export_csv("title-points")

d |>
  group_by(species) |>
  group_modify(\(g, key) {
    fit <- lm(bill_dep ~ bill_len, data = g)
    x <- range(g$bill_len)
    tibble(x = x, y = predict(fit, tibble(bill_len = x)))
  }) |>
  ungroup() |>
  export_csv("title-fits")

d |>
  summarize(mass = mean(body_mass), .by = species) |>
  export_csv("title-mass")

penguins |>
  select(species, island, bill_len, body_mass) |>
  slice(c(1, 2, 153, 154, 277, 278)) |>
  export_csv("title-rows")
