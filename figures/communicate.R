source("figures/theme.R")

d <- penguins |> drop_na(body_mass, sex)

p1 <- d |>
  summarize(m = mean(body_mass), .by = c(species, sex)) |>
  ggplot(aes(species, m, fill = sex)) +
  geom_col(position = "dodge") +
  theme_gray(base_size = 6, base_family = "Fira Sans") +
  labs(x = "species", y = "mean body mass", fill = "sex") +
  theme(legend.key.size = unit(6, "pt"))

sm <- d |>
  summarize(m = mean(body_mass), ci = qt(.975, n() - 1) * sd(body_mass) / sqrt(n()), .by = c(species, sex))
sex_cols <- c(female = lecture_colours[["grey"]], male = lecture_colours[["blue"]])
lab <- sm |> filter(species == "Adelie")

p2 <- ggplot(sm, aes(m, species, color = sex)) +
  geom_pointrange(aes(xmin = m - ci, xmax = m + ci), position = position_dodge(0.5), size = 0.2, linewidth = 0.9) +
  geom_text(data = lab, aes(label = sex, hjust = ifelse(sex == "female", 0.6, 0)), position = position_dodge(0.5), vjust = -1,
            family = "Fira Sans", size = 2.5, fontface = "bold") +
  scale_color_manual(values = sex_cols) +
  scale_y_discrete(limits = rev, expand = expansion(add = c(0.6, 0.9))) +
  scale_x_continuous(breaks = c(3500, 4500, 5500), expand = expansion(mult = c(0.2, 0.05))) +
  labs(x = "Mean body mass (g), 95 % CI", y = NULL,
       title = "Gentoo penguins are the heaviest") +
  theme(legend.position = "none", plot.title = element_text(size = 7.5, face = "bold"),
        plot.title.position = "plot", plot.margin = margin(4, 12, 4, 4))

save_figure(p1, "communicate-1", 3.2, 2.4, shown = 4.6)
save_figure(p2, "communicate-2", 3.2, 2.4, shown = 4.6)
