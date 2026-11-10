source("figures/theme.R")

d <- penguins |> drop_na(flipper_len, body_mass)

base <- ggplot(d, aes(flipper_len, body_mass)) +
  geom_point(alpha = .6, size = .8, color = lecture_colours[["blue"]]) +
  labs(x = "Flipper length (mm)", y = "Body mass (g)")

save_figure(base + expand_limits(x = 0, y = 0), "axis-zero-1", 2.6, 2.2, shown = 4)
save_figure(base + scale_x_continuous(breaks = c(180, 200, 220)), "axis-zero-2", 2.6, 2.2, shown = 4)
