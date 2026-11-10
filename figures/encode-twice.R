source("figures/theme.R")
d <- drop_na(penguins, bill_len, bill_dep)
base <- ggplot(d, aes(bill_len, bill_dep)) +
  labs(x = "Bill length (mm)", y = "Bill depth (mm)")

p1 <- base +
  geom_point(aes(color = species), size = 1.2, alpha = .8) +
  scale_color_manual(values = species_colours, name = NULL) +
  theme(legend.text = element_text(size = 6), legend.key.width = unit(4, "pt"),
        legend.margin = margin(0, 0, 0, 0)) +
  guides(color = guide_legend(override.aes = list(size = 1.5)))

labels <- tibble(species = factor(c("Adelie", "Chinstrap", "Gentoo"), levels(d$species)),
                 bill_len = c(35, 55, 55), bill_dep = c(21.8, 21.3, 13.3))
p2 <- base +
  geom_point(aes(color = species, shape = species), size = 1.4, alpha = .8) +
  geom_label(aes(label = species, color = species), labels, fill = "white", linewidth = 0,
             size = 2.5, fontface = "bold", family = "Fira Sans") +
  scale_color_manual(values = species_colours) +
  scale_shape_manual(values = c(16, 17, 15)) +
  theme(legend.position = "none")

save_figure(p1, "encode-twice-1", 2.6, 2.2, shown = 5)
save_figure(p2, "encode-twice-2", 2.6, 2.2, shown = 5)
