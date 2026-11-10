# the handout; `latexmk r-statistics-anim.tex` builds every overlay; `make -j5` builds all versions and publishes the PDFs
@default_files = ('r-statistics.tex');
$pdf_mode = 1;
$pdflatex = 'pdflatex -shell-escape -interaction=nonstopmode -file-line-error %O %S';
$aux_dir = 'build';
# the PDF stays in build/ until a run is complete: make copies it out, so a viewer never shows a half-finished pass
$out_dir = 'build';
$bibtex_use = 2;
$max_repeat = 6;

# magic-r keeps many names per listing, and beamer typesets every overlay as a listing of its own.
$ENV{pool_size} = 30000000;
$ENV{hash_extra} = 600000;
# the overlays of the animated version make more names (strings) than the default allows
$ENV{max_strings} = 1500000;
# what the default TeX Live of the CI has too little of: extra_mem_* also works without rebuilding the format.
# The first pass without an aux file is the hungriest: anim-notes peaks at 11.3M string characters and 64M words.
$ENV{extra_mem_top} = 60000000;
$ENV{extra_mem_bot} = 60000000;

ensure_path('TEXINPUTS', './magic-r//', './xlistings//', './code-animation//', './fancyqr//', './slide-template-uulm//', '.');

# The R packages of rproject.toml, also for magic-r, whose Rscript --vanilla skips .Rprofile.
# The snapshots of make have no rv/: they keep the library that make exports.
if (-d 'rv') {
  chomp(my $library = `rv library`);
  if ($? == 0) {
    require File::Spec;
    $ENV{R_LIBS_USER} = File::Spec->rel2abs($library);
  } else {
    warn "Could not find the library of rv, is rv installed?\n";
  }
}

# Every figures/<name>.R writes figures/out/<name>.stamp; rerun a script when it, or the shared theme, is newer.
sub render_figures {
  my $theme = 'figures/theme.R';
  for my $script (glob 'figures/*.R') {
    next if $script eq $theme;
    (my $name = $script) =~ s{^figures/(.*)\.R$}{$1};
    my $stamp = "figures/out/$name.stamp";
    my $newest = (stat $script)[9];
    my $theme_time = (stat $theme)[9] // 0;
    $newest = $theme_time if $theme_time > $newest;
    next if -e $stamp && (stat $stamp)[9] >= $newest;
    print "Rendering $script\n";
    if (system('Rscript', $script) == 0) {
      open my $fh, '>', $stamp; close $fh;
    } else {
      warn "Rscript $script failed\n";
    }
  }
}
render_figures() unless $ENV{R_STATISTICS_RC};

sub shinylive_link {
  my ($app, $link) = ('examples/app.R', 'examples/app-url.tex');
  return if -e $link && (stat $link)[9] >= (stat $app)[9];
  system("node tools/shinylive-url.mjs $app > $link") == 0
    or warn "Could not write $link\n";
}
shinylive_link() unless $ENV{R_STATISTICS_RC};

# the Quarto report shown on the slides is rendered for real
sub quarto_report {
  my ($qmd, $pdf) = ('examples/report/analysis.qmd', 'examples/report/analysis.pdf');
  return if -e $pdf && (stat $pdf)[9] >= (stat $qmd)[9];
  system('quarto', 'render', $qmd) == 0 or warn "Could not render $qmd\n";
}
quarto_report() unless $ENV{R_STATISTICS_RC};

# pdflatex directly (never latexmk, which would read this file again); twice for the bounding box.
sub title_image {
  my ($tex, $pdf) = ('titleimage/title.tex', 'titleimage/title.pdf');
  my $newest = 0;
  for (grep { -e } $tex, 'figures/out/colours.tex', glob 'figures/out/title-*.csv') {
    my $time = (stat $_)[9];
    $newest = $time if $time > $newest;
  }
  return if -e $pdf && (stat $pdf)[9] >= $newest;
  mkdir 'titleimage/build';
  for (1 .. 2) {
    system("cd titleimage && pdflatex -interaction=nonstopmode -output-directory=build title.tex > /dev/null") == 0
      or warn "Could not build the title image, see titleimage/build/title.log\n";
  }
  rename 'titleimage/build/title.pdf', $pdf;
}
title_image() unless $ENV{R_STATISTICS_RC}++;
