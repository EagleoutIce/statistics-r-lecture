source("figures/theme.R")

set.seed(11)
d <- tibble(temp = seq(0, 40, length.out = 120)) |>
  mutate(sales = 100 - 0.22 * (temp - 20)^2 + rnorm(n(), 0, 8))
r <- cor(d$temp, d$sales)

p <- ggplot(d, aes(temp, sales)) +
  geom_point(color = lecture_colours[["blue"]], alpha = 0.8) +
  geom_smooth(method = "loess", formula = y ~ x, se = FALSE, color = lecture_colours[["blue"]]) +
  annotate("label", x = 3, y = 20, label = sprintf("r = %.2f", r), hjust = 0, family = "Fira Sans",
           size = 3.5, color = lecture_colours[["red"]], fill = "white", linewidth = 0) +
  labs(x = "Daily temperature (\u00b0C)", y = "Ice cream sales (scoops)")

save_figure(p, "icecream", 3, 2.2)
