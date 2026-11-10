source("figures/theme.R")

set.seed(1)
n <- 5000
dens <- list(
  Normal = \(x) dnorm(x, 5, 1.5),
  `Right-skewed` = \(x) dlnorm(x - .8, log(2), .7),
  Bimodal = \(x) .5 * dnorm(x, 2.5, .9) + .5 * dnorm(x, 7.5, .9),
  Uniform = \(x) dunif(x, 0, 10)
)
labs_two <- c(
  Normal = "Normal\none symmetric peak",
  `Right-skewed` = "Right-skewed\nlong right tail",
  Bimodal = "Bimodal\ntwo peaks",
  Uniform = "Uniform\nequally common"
)
lev <- unname(labs_two)
d <- tibble(
  dist = factor(lev, lev),
  x = list(
    rnorm(n, 5, 1.5), .8 + rlnorm(n, log(2), .7),
    ifelse(runif(n) < .5, rnorm(n, 2.5, .9), rnorm(n, 7.5, .9)), runif(n, 0, 10)
  )
) |> unnest(x) |> filter(x >= 0, x <= 10)

xs <- seq(0, 10, length.out = 300)
curves <- tibble(dist = factor(lev, lev), f = dens) |>
  reframe(x = xs, y = f[[1]](xs), .by = dist)

stats <- d |> summarize(mean = mean(x), median = median(x), .by = dist)
top <- max(curves$y[curves$dist == lev[2]])
marks <- stats |>
  filter(dist == lev[2]) |>
  pivot_longer(c(mean, median), names_to = "stat", values_to = "x") |>
  mutate(y = top * 1.35, hjust = ifelse(stat == "mean", -0.12, 1.12))

red <- lecture_colours[["red"]]
grey <- "#424242"
p <- ggplot(d, aes(x)) +
  geom_histogram_round(aes(y = after_stat(density)), binwidth = .5, boundary = 0,
                       fill = lecture_colours[["blue"]], alpha = .55) +
  geom_line(aes(y = y), curves, color = grey, linewidth = .35) +
  geom_vline(aes(xintercept = median), stats, color = grey, linewidth = .4, linetype = "dashed") +
  geom_vline(aes(xintercept = mean), stats, color = red, linewidth = .4) +
  geom_blank(aes(y = y), tibble(dist = factor(lev, lev), y = tapply(curves$y, curves$dist, max) * 1.6), inherit.aes = FALSE) +
  geom_text(aes(x = x, y = y, label = stat, hjust = hjust, color = stat), marks,
            size = 2.4, family = "Fira Sans", show.legend = FALSE) +
  coord_cartesian(clip = "off") +
  scale_color_manual(values = c(mean = red, median = grey)) +
  facet_wrap(~ dist, scales = "free_y", nrow = 1) +
  scale_x_continuous(breaks = c(0, 5, 10)) +
  scale_y_continuous(breaks = NULL, expand = expansion(mult = c(0, .1))) +
  labs(x = "Value", y = "Density") +
  theme_lecture(8) +
  theme(strip.text = element_text(size = 6, lineheight = 1.05), panel.grid = element_blank(),
        panel.spacing = unit(10, "pt"))

save_figure(p, "distributions", 5, 2.4, shown = 10.5)
