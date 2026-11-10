source("figures/theme.R")

d <- penguins |> drop_na(flipper_len, body_mass)

p <- ggplot(d, aes(flipper_len, body_mass, color = species)) +
  geom_point(alpha = .6, size = .8) +
  stat_smooth(method = "lm", linewidth = .6) +
  scale_color_manual(values = species_colours) +
  coord_cartesian() +
  facet_wrap(~ island) +
  scale_x_continuous(breaks = c(180, 200, 220)) +
  guides(color = guide_legend(override.aes = list(fill = NA))) +
  labs(x = "Flipper length (mm)", y = "Body mass (g)", color = NULL) +
  theme_minimal(base_size = 8, base_family = "Fira Sans") +
  theme(legend.position = "top")

save_figure(p, "grammar", 4.4, 2.4, shown = 9.5)
