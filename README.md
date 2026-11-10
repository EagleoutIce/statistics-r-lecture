# Statistics with R

A lecture for Research Software Engineering: statistics and visualization, honest reporting, R (ggplot2, Shiny), and Quarto.

## Slides

[Handout](https://github.com/EagleoutIce/statistics-r-lecture/releases/download/latest/r-statistics.pdf) · [Lecture 1](https://github.com/EagleoutIce/statistics-r-lecture/releases/download/latest/r-statistics-lecture-1.pdf) · [Lecture 2](https://github.com/EagleoutIce/statistics-r-lecture/releases/download/latest/r-statistics-lecture-2.pdf) · [Without quiz solutions](https://github.com/EagleoutIce/statistics-r-lecture/releases/download/latest/r-statistics-nosolutions.pdf) · [Animated](https://github.com/EagleoutIce/statistics-r-lecture/releases/download/latest/r-statistics-anim.pdf)

Built by CI on every change, see the [release](https://github.com/EagleoutIce/statistics-r-lecture/releases/tag/latest).

## Building

```sh
git clone --recurse-submodules https://github.com/EagleoutIce/statistics-r-lecture.git
cd statistics-r-lecture
rv sync       # the R packages pinned in rv.lock
make -j4      # every version, the PDFs appear next to the sources
make handout  # only the handout and its two lectures
```

Needs [TeX Live](https://tug.org/texlive/), [R](https://www.r-project.org/) 4.6, [rv](https://github.com/A2-ai/rv), [Quarto](https://quarto.org/), [Node.js](https://nodejs.org/), [qpdf](https://qpdf.sourceforge.io/), [Poppler](https://poppler.freedesktop.org/), and [Fira Sans](https://github.com/mozilla/Fira).
Uses [FancyBeamerUULM](https://github.com/sp-uulm/FancyBeamerUULM), [magic-r](https://github.com/EagleoutIce/magic-r), [xlistings](https://github.com/EagleoutIce/xlistings), [code-animation](https://github.com/EagleoutIce/code-animation), [fancyqr](https://github.com/EagleoutIce/fancyqr), and [flowR](https://github.com/flowr-analysis/flowr).
