#!/usr/bin/env sh
# Splits a version of the slides into one PDF per lecture: split-lectures.sh [in.pdf] [out-prefix]
# Each has its own title page with its date, and keeps the references and the code appendix, so that links and the
# quiz buttons (layers) keep working. The last page of a frame counts, as an animated frame has many.
set -eu
in=${1:-r-statistics.pdf}
out=${2:-r-statistics-lecture}
page_of() { pdftotext "$in" - 2>/dev/null | awk -v k="$1" 'BEGIN { RS = "\f" } index($0, k) == 1 { found = NR } END { if (found) print found }'; }
pages=$(pdfinfo "$in" | awk '/^Pages/ { print $2 }')
cut=$(page_of "Takeaways: Communicating")
last=$(page_of "Summary")
[ -n "$cut" ] && [ -n "$last" ] || { echo "could not find the end of a lecture in $in" >&2; exit 1; }
qpdf --warning-exit-0 --no-warn "$in" --pages . "1-$cut,$((last + 1))-$pages" -- "$out-1.pdf"
qpdf --warning-exit-0 --no-warn "$in" --pages . "$((cut + 1))-$pages" -- "$out-2.pdf"
echo "lecture 1: pages 1-$cut, lecture 2: pages $((cut + 1))-$last, appendix from $((last + 1)) of $pages"
