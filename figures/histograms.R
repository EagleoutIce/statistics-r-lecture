source("figures/theme.R")

binwidths <- c(2, 0.25, 0.05)

for (i in seq_along(binwidths)) {
  p <- ggplot(faithful, aes(eruptions)) +
    geom_histogram_round(binwidth = binwidths[i], boundary = 0, fill = lecture_colours[["blue"]], alpha = .7,
                         gap = if (binwidths[i] < 0.1) 0.1 else 0.5) +
    scale_x_continuous(limits = c(0, 6)) +
    labs(x = "Eruption duration (min)", y = "Count",
         subtitle = paste("binwidth =", binwidths[i]))
  save_figure(p, paste0("hist-binwidth-", i), 2.4, 1.8, shown = 4.1)
}
