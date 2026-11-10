library(ggplot2)
library(dplyr, warn.conflicts = FALSE)
library(tidyr)
library(scales)

lecture_colours <- c(
  blue = "#5E3A68", red = "#A8424C", orange = "#B8475A",
  green = "#B39BC4", grey = "#7F7F7F", light = "#D9D9D9"
)

species_colours <- c(Adelie = "#B8475A", Chinstrap = "#C98AB8", Gentoo = "#3E2A5E")

local({
  dir.create("figures/out", showWarnings = FALSE, recursive = TRUE)
  colours <- c(species_colours, plotblue = lecture_colours[["blue"]], Warn = lecture_colours[["red"]])
  writeLines(
    sprintf("\\definecolor{%s}{HTML}{%s}", names(colours), sub("#", "", colours)),
    "figures/out/colours.tex"
  )
})

theme_lecture <- function(base_size = 8) {
  theme_minimal(base_size = base_size, base_family = "Fira Sans") +
    theme(
      panel.grid.major = element_line(colour = lecture_colours[["light"]], linewidth = 0.25),
      panel.grid.minor = element_blank(),
      legend.position = "top",
      plot.background = element_rect(fill = "white", colour = NA),
      plot.margin = margin(4, 6, 4, 4)
    )
}

theme_set(theme_lecture())

GeomColRound <- ggproto("GeomColRound", GeomCol,
  extra_params = c(GeomCol$extra_params, "r", "gap"),
  draw_panel = function(self, data, panel_params, coord, r = 2, gap = 0, ...) {
    d <- coord$transform(data, panel_params)
    a <- seq(0, pi / 2, length.out = 8)
    bars <- lapply(seq_len(nrow(d)), function(i) with(d[i, ], {
      l <- grid::unit(xmin, "npc") + grid::unit(gap / 2, "pt")
      rt <- grid::unit(xmax, "npc") - grid::unit(gap / 2, "pt")
      b <- grid::unit(ymin, "npc")
      tp <- grid::unit(ymax, "npc")
      rr <- grid::unit.pmin(grid::unit(r, "pt"), 0.5 * (rt - l), tp - b)
      grid::polygonGrob(
        x = grid::unit.c(l, l + rr * (1 - cos(a)), rt - rr * (1 - sin(a)), rt),
        y = grid::unit.c(b, tp - rr * (1 - sin(a)), tp - rr * (1 - cos(a)), b),
        gp = grid::gpar(fill = alpha(fill, alpha), col = NA)
      )
    }))
    grid::gTree(children = do.call(grid::gList, bars))
  }
)
geom_col_round <- function(mapping = NULL, data = NULL, ..., r = 2, gap = 0) {
  layer(data = data, mapping = mapping, stat = "identity", geom = GeomColRound,
        position = "stack", params = list(r = r, gap = gap, ...))
}
geom_histogram_round <- function(mapping = NULL, data = NULL, ..., r = 1.5, gap = 0.5) {
  layer(data = data, mapping = mapping, stat = "bin", geom = GeomColRound,
        position = "stack", params = list(r = r, gap = gap, ...))
}

save_figure <- function(plot, name, width, height, shown = NULL) {
  if (!any(startsWith(commandArgs(), "--file="))) return(print(plot))
  dir.create("figures/out", showWarnings = FALSE, recursive = TRUE)
  k <- if (is.null(shown)) 1 else shown / 2.54 / width
  source("tools/figure-fonts.R")
  ggsave(
    file.path("figures/out", paste0(name, ".pdf")), plot,
    device = cairo_pdf, width = width * k, height = height * k, units = "in"
  )
}

export_csv <- function(data, name) {
  dir.create("figures/out", showWarnings = FALSE, recursive = TRUE)
  write.csv(data, file.path("figures/out", paste0(name, ".csv")), row.names = FALSE, quote = FALSE)
}
