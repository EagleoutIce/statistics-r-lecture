source("figures/theme.R")

theme_set(theme_gray(base_size = 7.5, base_family = "Fira Sans"))

d <- penguins |> drop_na(flipper_len, body_mass)

limits <- list(
  scale_x_continuous(limits = range(d$flipper_len)),
  scale_y_continuous(limits = range(d$body_mass))
)

step1 <- ggplot(d, aes(x = flipper_len, y = body_mass, color = species)) + limits
step2 <- step1 + geom_point(alpha = .7)
step3 <- step2 + geom_smooth(method = "lm")
step4 <- step3 + scale_color_manual(values = species_colours)
step5 <- step4 + labs(x = "Flipper length (mm)", y = "Body mass (g)", color = NULL)
step6 <- step5 + theme_minimal(base_size = 7.5, base_family = "Fira Sans")

step7 <- step6 + labs(title = "Heavier penguins have longer flippers") + theme(plot.title.position = "plot")

ends <- d |>
  summarize(
    x = max(flipper_len),
    y = predict(lm(body_mass ~ flipper_len), tibble(flipper_len = max(flipper_len))),
    .by = species
  ) |>
  arrange(y) |>
  mutate(label_x = max(d$flipper_len) + 4, label_y = pmax(y, lag(y, default = -Inf) + 380))

step8 <- step7 +
  scale_x_continuous(limits = c(min(d$flipper_len), max(d$flipper_len) + 22)) +
  geom_segment(
    data = ends, aes(x, y, xend = label_x - 1, yend = label_y),
    linetype = "dotted", linewidth = 0.3
  ) +
  geom_text(
    data = ends, aes(label_x, label_y, label = species), hjust = 0,
    fontface = "bold", size = 2.5, family = "Fira Sans"
  )

steps <- list(step1, step2, step3, step4, step5, step6, step7, step8)

for (i in seq_along(steps)) {
  legend <- if (i == 8) "none" else "top"
  save_figure(steps[[i]] + theme(legend.position = legend), paste0("gg-step-", i), 3.4, 2.5, shown = 6.4)
}
