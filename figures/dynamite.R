source("figures/theme.R")

d <- penguins |> drop_na(body_mass)
sm <- d |>
  summarize(m = mean(body_mass), se = sd(body_mass) / sqrt(n()),
            ci = qt(.975, n() - 1) * se, .by = species)

base <- ggplot(d, aes(species, body_mass, color = species, fill = species)) +
  scale_color_manual(values = species_colours) +
  scale_fill_manual(values = species_colours) +
  scale_y_continuous(limits = c(0, 6500), breaks = seq(0, 6000, 2000)) +
  labs(x = NULL, y = "Body mass (g)") +
  theme(legend.position = "none")

p1 <- base +
  geom_col_round(data = sm, aes(y = m), width = 0.6) +
  geom_errorbar(data = sm, aes(y = m, ymin = m - se, ymax = m + se), width = 0.2, color = "black")

p2 <- base +
  geom_jitter(width = 0.2, alpha = 0.5, size = 0.7) +
  geom_pointrange(data = sm, aes(y = m, ymin = m - ci, ymax = m + ci), color = "black", size = 0.4)

save_figure(p1, "dynamite-1", 2.4, 2.3, shown = 4.3)
save_figure(p2, "dynamite-2", 2.4, 2.3, shown = 4.3)
