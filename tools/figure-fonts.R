# Exact glyph spacing for the rendered figures. Only used when the figures are built for the slides, not in the playground.
font <- function(style) system(sprintf("fc-match -f '%%{file}' 'Fira Sans:%s'", style), intern = TRUE)
sysfonts::font_add("Fira Sans", font("regular"), font("bold"))
showtext::showtext_auto()
showtext::showtext_opts(dpi = 1200)
