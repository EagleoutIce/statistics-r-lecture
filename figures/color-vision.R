source("figures/theme.R")

# Machado et al. (2009), deuteranopia, severity 1, on linear RGB
deutan <- matrix(c(
  .367322, .860646, -.227968,
  .280085, .672501, .047413,
  -.011820, .042940, .968881
), 3, byrow = TRUE)

simulate <- function(cols) {
  lin <- apply(col2rgb(cols) / 255, 2, \(v) ifelse(v <= .04045, v / 12.92, ((v + .055) / 1.055)^2.4))
  out <- pmin(pmax(deutan %*% lin, 0), 1)
  out <- ifelse(out <= .0031308, 12.92 * out, 1.055 * out^(1 / 2.4) - .055)
  rgb(out[1, ], out[2, ], out[3, ])
}

volcano_long <- expand_grid(y = seq_len(ncol(volcano)), x = seq_len(nrow(volcano))) |>
  mutate(z = volcano[cbind(x, y)])

rb <- colorRampPalette(rainbow(7))(256)
vi <- viridisLite::viridis(256)
pal <- list(
  "Rainbow" = rb, "Rainbow,\ndeuteranopia" = simulate(rb),
  "Viridis" = vi, "Viridis,\ndeuteranopia" = simulate(vi)
)
breaks <- seq(min(volcano_long$z), max(volcano_long$z), length.out = 257)
d <- purrr::imap(pal, \(cols, nm) mutate(volcano_long, scale = nm,
                                         col = cols[findInterval(z, breaks, all.inside = TRUE)])) |>
  bind_rows() |>
  mutate(scale = factor(scale, names(pal)))

p <- ggplot(d, aes(x, y, fill = col)) +
  geom_raster() +
  scale_fill_identity() +
  coord_fixed(expand = FALSE) +
  facet_wrap(~ scale, nrow = 1) +
  theme_void(base_size = 9, base_family = "Fira Sans") +
  theme(strip.text = element_text(face = "bold", margin = margin(b = 3)),
        plot.background = element_rect(fill = "white", colour = NA),
        panel.spacing = unit(.08, "in"), plot.margin = margin(4, 4, 4, 4))

save_figure(p, "color-vision", 5, 1.6, shown = 11.5)
