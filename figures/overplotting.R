source("figures/theme.R")
library(hexbin)

base <- ggplot(diamonds, aes(carat, price)) +
  scale_y_continuous(labels = label_dollar()) +
  labs(x = "Carat", y = "Price (USD)")

p1 <- base + geom_point(size = .5, color = lecture_colours[["blue"]])
p2 <- base + geom_point(alpha = .05, size = .5, color = lecture_colours[["blue"]])
p3 <- base +
  geom_hex(bins = 40) +
  scale_fill_viridis_c(transform = "log10") +
  theme(legend.position = "top", legend.key.width = unit(0.22, "in"),
        legend.key.height = unit(0.06, "in"), legend.margin = margin(0, 0, -6, 0)) +
  labs(fill = "Count")

save_figure(p1, "overplot-1", 2.3, 1.8, shown = 4.1)
save_figure(p2, "overplot-2", 2.3, 1.8, shown = 4.1)
save_figure(p3, "overplot-3", 2.3, 1.8, shown = 4.1)
