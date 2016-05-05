#!/bin/sh
TARGET=downloads

echo "Rendering downloads to $TARGET"

SLUG=`grep "^title:" _config.yml | sed 's/title: //' | sed -E 's/[.:?,!;]//g' | sed 's/ /_/g'`

# create directories if needed
mkdir -p $TARGET
mkdir -p _data

# generate new versions
# TODO only render if changed
#pandoc -s -S -f markdown+pipe_tables+footnotes -c test.css sections/*.md  -o downloads/$SLUG.html
pandoc --filter=_scripts/wpafilter.rb --latex-engine=xelatex -f markdown+pipe_tables+footnotes sections/*.md  -o $TARGET/$SLUG.pdf
pandoc -S --epub-cover-image=assets/cover.jpg --epub-metadata=_epub-metadata.yml -f markdown+pipe_tables+footnotes sections/*.md  -o $TARGET/$SLUG.epub
pandoc sections/*.md -t plain -o $TARGET/$SLUG.txt
pandoc sections/*.md -o $TARGET/$SLUG.md

ls -lh $TARGET/*

# generate yml list
ls -lh $TARGET/* \
  | sed 's/\ [^ ]*downloads/ downloads/' \
  | awk '{ split($9, a, "."); print "- permalink: " $9 "\n  title: " toupper(a[2]) " (" $5 ")" ; }' > _data/downloads.yml
