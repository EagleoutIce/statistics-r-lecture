source("figures/theme.R")
library(purrr)

set.seed(16)
pop <- penguins |> filter(species == "Adelie", sex == "male") |> pull(body_mass)
mu <- mean(pop)

cis <- map_dfr(1:20, \(i) {
  ci <- t.test(sample(pop, 10))$conf.int
  tibble(run = i, mean = mean(ci), lo = ci[1], hi = ci[2])
}) |>
  mutate(miss = lo > mu | hi < mu)

plot_ci <- function(d) {
  ggplot(d, aes(mean, run, xmin = lo, xmax = hi, color = miss)) +
    geom_vline(xintercept = mu, linewidth = 0.6, color = "#424242") +
    annotate("text", x = mu, y = 0, label = "true mean", hjust = -0.08, family = "Fira Sans", size = 2.5,
             fontface = "bold", color = "#424242") +
    geom_pointrange(size = 0.25, linewidth = 0.5) +
    scale_color_manual(values = c(`TRUE` = lecture_colours[["red"]], `FALSE` = lecture_colours[["blue"]])) +
    scale_y_reverse(limits = c(20.5, -0.5)) +
    scale_x_continuous(limits = range(cis$lo, cis$hi)) +
    labs(x = "Body mass (g)", y = "Sample") +
    theme(legend.position = "none", axis.text.y = element_blank(), panel.grid.major.y = element_blank())
}

save_figure(plot_ci(slice_head(cis, n = 5)), "ci-coverage-1", 4.2, 2.6, shown = 7.2)
save_figure(plot_ci(cis), "ci-coverage-2", 4.2, 2.6, shown = 7.2)
