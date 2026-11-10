source("figures/theme.R")

groups <- tibble(group = LETTERS[1:5], value = c(17, 18, 20, 22, 23)) |>
  mutate(group = factor(group, levels = group))

cols <- colorRampPalette(c("#3F2449", "#B39BC4"))(5)

pie <- ggplot(groups, aes(x = "", y = value, fill = group)) +
  geom_col(width = 1, color = "white", linewidth = 0.8) +
  geom_text(aes(label = group), position = position_stack(vjust = 0.5),
            color = "white", family = "Fira Sans", fontface = "bold", size = 3) +
  coord_polar(theta = "y") +
  scale_fill_manual(values = cols) +
  theme_void(base_size = 9, base_family = "Fira Sans") +
  theme(legend.position = "none")

bar <- ggplot(groups, aes(reorder(group, -value), value, fill = reorder(group, -value))) +
  geom_col_round(width = 0.7) +
  geom_text(aes(label = value), vjust = -0.4, family = "Fira Sans", size = 2.6) +
  scale_fill_manual(values = cols[c(5, 4, 3, 2, 1)]) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.22))) +
  labs(x = NULL, y = NULL) +
  theme(legend.position = "none", axis.text.y = element_blank(), panel.grid.major = element_blank(),
        axis.text.x = element_text(size = 8))

save_figure(pie, "pie-chart", 2.4, 2.4, shown = 2.6)
save_figure(bar, "bar-chart", 3, 2.4, shown = 2.9)
