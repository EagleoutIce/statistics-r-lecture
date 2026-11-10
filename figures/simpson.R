source("figures/theme.R")

d <- penguins |> drop_na(bill_len, bill_dep)

base <- ggplot(d, aes(bill_len, bill_dep)) +
  scale_x_continuous(limits = range(d$bill_len)) +
  scale_y_continuous(limits = range(d$bill_dep)) +
  labs(x = "Bill length (mm)", y = "Bill depth (mm)")

labels <- tibble(species = c("Adelie", "Chinstrap", "Gentoo"),
                 bill_len = c(35, 51.5, 54), bill_dep = c(21, 21.2, 13.6))

p1 <- base +
  geom_point(color = lecture_colours[["grey"]], alpha = 0.7) +
  geom_smooth(method = "lm", se = FALSE, color = lecture_colours[["red"]])

p2 <- base +
  geom_point(aes(color = species), alpha = 0.7) +
  geom_smooth(aes(group = 1), method = "lm", se = FALSE, color = lecture_colours[["grey"]],
              linetype = "dashed") +
  geom_smooth(aes(color = species), method = "lm", se = FALSE) +
  geom_label(data = labels, aes(label = species, color = species), fill = alpha("white", .8), linewidth = 0, fontface = "bold",
            family = "Fira Sans", size = 2.6) +
  scale_color_manual(values = species_colours) +
  theme(legend.position = "none")

save_figure(p1, "simpson-1", 3.4, 2.4, shown = 6.3)
save_figure(p2, "simpson-2", 3.4, 2.4, shown = 6.3)
