source("figures/theme.R")

d <- penguins |> drop_na(flipper_len, body_mass)
d$fitted <- fitted(lm(body_mass ~ flipper_len, d))
d$res <- resid(lm(body_mass ~ flipper_len, d))

p1 <- ggplot(d, aes(fitted, res, color = species)) +
  geom_hline(yintercept = 0, color = lecture_colours[["grey"]]) +
  geom_point(alpha = 0.7, size = 1) +
  scale_color_manual(values = species_colours) +
  labs(x = "Fitted body mass (g)", y = "Residual (g)", color = NULL) +
  theme(legend.position = "top", legend.margin = margin(0, 0, -6, 0), legend.text = element_text(size = 5.5, margin = margin(l = 1)),
        legend.key.width = unit(3, "pt"), legend.key.spacing.x = unit(3, "pt"), legend.box.margin = margin(0, 0, 0, -30)) +
  guides(color = guide_legend(override.aes = list(size = 1.5, alpha = 1)))

p2 <- ggplot(d, aes(sample = res, color = species)) +
  geom_qq_line(aes(color = NULL), color = lecture_colours[["grey"]]) +
  geom_qq(alpha = 0.7, size = 1) +
  scale_color_manual(values = species_colours) +
  labs(x = "Theoretical quantiles", y = "Residual quantiles (g)") +
  theme(legend.position = "none")

save_figure(p1, "residuals-1", 2.6, 2.3, shown = 4.2)
save_figure(p2, "residuals-2", 2.6, 2.3, shown = 4.2)
