source("figures/theme.R")

# simulated: sales rise with the temperature, then fall just as much on the hottest days
set.seed(4)
d <- tibble(temperature = seq(10, 40, length.out = 100)) |>
  mutate(sales = 500 - 1.6 * (temperature - 25)^2 + rnorm(n(), 0, 25))
r <- cor(d$temperature, d$sales)

p <- ggplot(d, aes(temperature, sales)) +
  geom_point(color = lecture_colours[["blue"]], size = 1.2, alpha = .8) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, color = lecture_colours[["red"]], linewidth = .7) +
  annotate("text", x = 25, y = 150, label = sprintf("r = %.2f", r), size = 3, family = "Fira Sans") +
  labs(x = "Temperature in degrees Celsius", y = "Ice cream sales")

save_figure(p, "correlation-curve", 3.4, 2.4, shown = 6.6)
