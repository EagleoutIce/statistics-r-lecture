source("figures/theme.R")

# simulated run times (ms) of two tools: 10 fresh processes each, 30 iterations per process.
# The first iterations are slow (warm-up), every process has its own level (memory layout, ...)
set.seed(7)
runs <- expand_grid(tool = c("A", "B"), process = 1:10, iteration = 1:30) |>
  mutate(
    steady = ifelse(tool == "A", 100, 94),
    level = rep(rnorm(20, 0, 3), each = 30),
    warmup = 60 * exp(-(iteration - 1) / 3),
    time = steady + level + warmup + rnorm(n(), 0, 1.5)
  )

# one process of tool A: warm-up, then steady state
p1 <- runs |>
  filter(tool == "A", process == 1) |>
  ggplot(aes(iteration, time)) +
  annotate("rect", xmin = 0.5, xmax = 10.5, ymin = -Inf, ymax = Inf, fill = lecture_colours[["light"]], alpha = 0.6) +
  annotate("text", x = 7.5, y = 152, label = "warm-up:\ndiscard", family = "Fira Sans", size = 2.5, color = "#424242") +
  geom_line(color = lecture_colours[["blue"]], linewidth = 0.5) +
  geom_point(color = lecture_colours[["blue"]], size = 0.9) +
  labs(x = "Iteration in one process", y = "Run time (ms)")

# the steady state of every process (mean of iterations 11-30), one point per process
steady <- runs |>
  filter(iteration > 10) |>
  summarize(time = mean(time), .by = c(tool, process))
med <- steady |> summarize(time = median(time), .by = tool)

p2 <- ggplot(steady, aes(tool, time)) +
  geom_jitter(width = 0.08, size = 1.3, color = lecture_colours[["blue"]], alpha = 0.7) +
  geom_crossbar(data = med, aes(ymin = time, ymax = time), width = 0.4, linewidth = 0.4, color = "#424242") +
  labs(x = "Tool", y = "Run time (ms)")

save_figure(p1, "benchmark-1", 2.6, 2.2, shown = 5)
save_figure(p2, "benchmark-2", 2, 2.2, shown = 3.4)

export_csv(steady, "benchmark-steady")
