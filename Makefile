# The handout is also split into one PDF per lecture for the students.
# All versions in parallel: make -j5 (or a single one, for example: make notes; from scratch: make -j5 rebuild).
# Each build runs on a copy of the sources in .snapshot/<version>, so that editing never disturbs a running build, and
# the PDF is only copied back here once it is complete, so that a viewer never shows a half-finished pass.
# The public copy has no speaker notes (notes/notes.tex), so it builds neither the note versions nor the report.
ifeq ($(wildcard notes/notes.tex),)
VERSIONS := handout anim nosolutions
else
VERSIONS := handout anim nosolutions notes anim-notes report
endif
.PHONY: all clean rebuild rv-sync prepare $(VERSIONS)
all: $(VERSIONS)

# The R packages of rproject.toml, installed once before the builds start. The snapshots share this library: magic-r
# runs Rscript --vanilla, which skips .Rprofile, so that every R finds the library through the environment.
# Without rv (as in CI, which installs the packages itself), R keeps its own library.
ifneq ($(shell command -v rv),)
export R_LIBS_USER := $(abspath $(shell rv library))
rv-sync:
	rv sync
else
rv-sync:
	@echo "rv is not installed: using the R packages of the system, not the versions of rv.lock"
endif
$(VERSIONS): rv-sync

# everything from scratch: make -j5 rebuild
rebuild: clean
	$(MAKE) all

clean:
	rm -rf .snapshot build

# The figures, the Shinylive link, the Quarto report, and the title image are made once, here in the sources: the
# snapshots get them with their stamps, so latexmk finds them up to date and neither renders nor reruns for them.
prepare: rv-sync
	perl -e 'sub ensure_path {} do "./latexmkrc"; die $$@ if $$@;'

# A run stopped halfway (Ctrl-C, fatal error) leaves cut-off .aux, .toc, ... files that break the first pass of the next
# run, and latexmk gives up on that pass. So a snapshot only keeps its build/ if the last run marked it as complete.
define build
	mkdir -p .snapshot/$(1)
	rsync -a --delete --exclude=.git --exclude=/.snapshot --exclude=/build --exclude=/rv --exclude=/.Rprofile --exclude='/*.pdf' ./ .snapshot/$(1)/
	cd .snapshot/$(1) && { [ -e build/.complete ] || rm -rf build; } && rm -f build/.complete && latexmk -silent $(2).tex && touch build/.complete
	cp .snapshot/$(1)/build/$(2).pdf .
	-cp .snapshot/$(1)/build/$(2).pdfpc . 2>/dev/null
endef

handout: prepare
	$(call build,handout,r-statistics)
	./tools/split-lectures.sh r-statistics.pdf
anim: prepare
	$(call build,anim,r-statistics-anim)
nosolutions: prepare
	$(call build,nosolutions,r-statistics-nosolutions)
notes: prepare
	$(call build,notes,r-statistics-notes)
anim-notes: prepare
	$(call build,anim-notes,r-statistics-anim-notes)
# the talk group report on its own, its flaws revealed by a click (optional content, e.g. in Okular)
report: prepare
	$(call build,report,report-flaws)
