source("figures/theme.R")

p <- ggplot(penguins, aes(species, body_mass)) +
  geom_boxplot(fill = lecture_colours[["light"]], color = lecture_colours[["grey"]]) +
  labs(x = NULL, y = "Body mass (g)")

save_figure(p, "quarto-boxplot", 2.6, 1.9)
