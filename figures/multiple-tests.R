source("figures/theme.R")
library(purrr)

set.seed(1)
ms <- c(1:10, seq(12, 50, 2))
reps <- 2000
# one effect: without a correction the chance of a false positive grows, with one it stays at 5 %.
# Under pure noise Holm and Benjamini-Hochberg give the same curve as Bonferroni, so one stands for all.
sim <- map_dfr(ms, \(m) {
  hits <- replicate(reps, {
    x <- matrix(rnorm(5 * m), 5)
    p <- 2 * pt(-abs(sqrt(5) * colMeans(x) / apply(x, 2, sd)), 4)
    any(p.adjust(p, "bonferroni") < .05)
  })
  tibble(m = m, fwer = mean(hits), method = "Bonferroni")
})

curve <- tibble(m = 1:50, fwer = 1 - .95^m, method = "Uncorrected")
cols <- c(Uncorrected = lecture_colours[["red"]], Bonferroni = lecture_colours[["blue"]])
ends <- tibble(m = 50, fwer = c(1 - .95^50, .05), method = c("Uncorrected", "Bonferroni"),
               label = c("uncorrected", "Bonferroni"))

p <- ggplot(mapping = aes(m, fwer, color = method)) +
  geom_hline(yintercept = .05, linetype = "dashed", color = lecture_colours[["grey"]]) +
  geom_line(data = curve, linewidth = 0.8) +
  geom_point(data = sim, size = 1.3) +
  geom_text(data = ends, aes(label = label), hjust = 0, nudge_x = 1.5, family = "Fira Sans",
            size = 2.5, fontface = "bold") +
  scale_color_manual(values = cols) +
  scale_x_continuous(expand = expansion(add = c(1, 0))) +
  scale_y_continuous(labels = label_percent()) +
  coord_cartesian(xlim = c(1, 50), ylim = c(0, 1), clip = "off") +
  labs(x = "Number of tests", y = "P(any false positive)") +
  theme(legend.position = "none", plot.margin = margin(4, 70, 4, 4))

save_figure(p, "multiple-tests", 4.2, 2.4, shown = 6.6)
