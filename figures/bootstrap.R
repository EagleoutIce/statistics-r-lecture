source("figures/theme.R")

set.seed(3)
x <- penguins |> filter(species == "Gentoo", sex == "male") |> pull(body_mass)
boot <- tibble(mean = replicate(1e4, mean(sample(x, replace = TRUE))))
q <- quantile(boot$mean, c(.025, .975))
qd <- tibble(x = q, label = c("2.5 %", "97.5 %"), hjust = c(1.1, -0.1))

p <- ggplot(boot, aes(mean)) +
  geom_histogram_round(bins = 40, fill = lecture_colours[["green"]], alpha = .7) +
  geom_vline(xintercept = q, color = lecture_colours[["red"]], linewidth = 0.6) +
  geom_text(data = qd, aes(x, Inf, label = label, hjust = hjust), vjust = 1.5, family = "Fira Sans",
            size = 2.4, color = lecture_colours[["red"]], inherit.aes = FALSE) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1))) +
  scale_x_continuous(expand = expansion(mult = 0.18)) +
  labs(x = "Mean body mass (g)", y = "Count")

save_figure(p, "bootstrap", 3.6, 2.2, shown = 5.2)
