source("figures/theme.R")

d <- tibble(i = 1:8, y = c(2, 3, 3, 4, 5, 6, 7, 9)) |>
  mutate(dev = y - mean(y), sign = ifelse(dev < 0, "neg", "pos"))
m <- mean(d$y)
s <- sd(d$y)
cols <- c(neg = lecture_colours[["red"]], pos = lecture_colours[["blue"]])

base <- ggplot(d, aes(i, y)) +
  geom_hline(yintercept = m, color = lecture_colours[["grey"]]) +
  annotate("text", x = 12, y = m, label = sprintf("mean = %.1f", m), hjust = 1, vjust = 1.6,
           size = 2.4, family = "Fira Sans") +
  scale_color_manual(values = cols, guide = "none") +
  scale_fill_manual(values = cols, guide = "none") +
  scale_x_continuous(breaks = 1:8, limits = c(0, 12)) +
  scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, 2)) +
  labs(x = "Observation", y = "Value")

p1 <- base +
  geom_segment(aes(xend = i, yend = m, color = sign), linewidth = .7) +
  geom_point(size = 1.8, color = "black") +
  annotate("text", x = 0.2, y = 9.7, hjust = 0, size = 2.4, family = "Fira Sans",
           label = sprintf("s = %.1f", s))

p2 <- base +
  coord_fixed(xlim = c(0, 12), ylim = c(0, 10)) +
  geom_rect(aes(xmin = i, xmax = i + abs(dev), ymin = pmin(y, m), ymax = pmax(y, m), fill = sign),
            alpha = .4, color = NA) +
  geom_segment(aes(xend = i, yend = m, color = sign), linewidth = .7) +
  geom_point(size = 1.8, color = "black") +
  annotate("text", x = 0.2, y = 9.7, hjust = 0, size = 2.4, family = "Fira Sans",
           label = sprintf("s^2 == %.1f", s^2), parse = TRUE)

save_figure(p1, "deviations", 3.4, 2.4, shown = 5)
save_figure(p2, "deviations-squares", 3.4, 2.4, shown = 5)
