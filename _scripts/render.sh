#!/bin/sh
echo "Rendering downloads"

SLUG=`grep "^title:" _config.yml | sed 's/title: //' | sed -E 's/[.:?,!;]//g' | sed 's/ /_/g'`

# create directories if needed
mkdir -p _site/downloads

# generate new versions
# TODO only render if changed
#pandoc -s -S -f markdown+pipe_tables+footnotes -c test.css _source/*.md  -o downloads/$SLUG.html
pandoc --latex-engine=xelatex -f markdown+pipe_tables+footnotes sections/*.md  -o _site/downloads/$SLUG.pdf
pandoc -S --epub-cover-image=assets/cover.jpg --epub-metadata=_epub-metadata.yml -f markdown+pipe_tables+footnotes sections/*.md  -o _site/downloads/$SLUG.epub
pandoc _source/*.md -t plain -o _site/downloads/$SLUG.txt
pandoc sections/*.md -o _site/downloads/$SLUG.md

# generate yml list
ls -lh _site/downloads/* \
  | sed 's/_site\///' \
  | awk '{ split($9, a, "."); print "- permalink: " $9 "\n  title: " toupper(a[2]) " (" $5 ")" ; }' > _data/downloads.yml
