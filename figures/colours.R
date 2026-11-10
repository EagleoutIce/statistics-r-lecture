source("figures/theme.R")

volcano_long <- expand_grid(y = seq_len(ncol(volcano)), x = seq_len(nrow(volcano))) |>
  mutate(z = volcano[cbind(x, y)])

to_gray <- function(cols) {
  rgb <- col2rgb(cols)
  gray((0.299 * rgb[1, ] + 0.587 * rgb[2, ] + 0.114 * rgb[3, ]) / 255)
}

rainbow_cols <- colorRampPalette(rainbow(7))(256)
scales <- list(
  "volcano-rainbow" = rainbow_cols,
  "volcano-viridis" = viridisLite::viridis(256),
  "volcano-rainbow-grey" = to_gray(rainbow_cols),
  "volcano-viridis-grey" = to_gray(viridisLite::viridis(256))
)

for (name in names(scales)) {
  p <- ggplot(volcano_long, aes(x, y, fill = z)) +
    geom_raster() +
    scale_fill_gradientn(colours = scales[[name]]) +
    coord_fixed(expand = FALSE) +
    labs(fill = "Height (m)") +
    theme_void(base_size = 6, base_family = "Fira Sans") +
    theme(legend.title = element_text(), legend.key.height = unit(0.2, "in"), legend.key.width = unit(0.05, "in"))
  save_figure(p, name, 2.2, 1.6, shown = 2.9)
}
