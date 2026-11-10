source("figures/theme.R")

chicks <- as_tibble(ChickWeight) |> mutate(Chick = factor(Chick, ordered = FALSE))

p1 <- ggplot(chicks, aes(Time, weight, color = Chick, group = Chick)) +
  geom_line(linewidth = 0.3) +
  scale_color_manual(values = hue_pal()(nlevels(chicks$Chick))) +
  labs(x = "Time (days)", y = "Weight (g)") +
  theme(legend.position = "none")

diet_means <- chicks |>
  summarize(weight = mean(weight), .by = c(Diet, Time))

mean_label <- diet_means |> filter(Diet == 1, Time == 0) |> mutate(Time = 1)

p2 <- ggplot(chicks, aes(Time, weight)) +
  geom_line(aes(group = Chick), color = lecture_colours[["light"]], linewidth = 0.3) +
  geom_line(data = diet_means, color = lecture_colours[["blue"]], linewidth = 0.9) +
  geom_text(data = mean_label, label = "mean", color = lecture_colours[["blue"]],
            fontface = "bold", family = "Fira Sans", size = 2.5, hjust = 0, vjust = -1.2) +
  facet_wrap(~Diet, labeller = as_labeller(\(x) paste("Diet", x))) +
  labs(x = "Time (days)", y = "Weight (g)") +
  scale_y_continuous(breaks = c(100, 300)) +
  theme(strip.text = element_text(size = 7.5, face = "bold"), axis.text = element_text(size = 6.5),
        axis.title = element_text(size = 8), panel.spacing = unit(0.1, "in"))

save_figure(p1, "spaghetti-1", 3.2, 2.6, shown = 5.3)
save_figure(p2, "spaghetti-2", 3.2, 2.6, shown = 5.3)
