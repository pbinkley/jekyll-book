#!/bin/sh

SLUG=What_Is_Right_with_Marriage

# create directories if needed
mkdir -p _data
mkdir -p downloads

# remove old versions
rm downloads/*

# process md
ls _source/*.md | xargs -n 1 -I {} echo {} | sed 's/_source\///' \
| xargs -n 1 -I {} echo grep -v \"^## \" _source/{} ">" sections/{} | sh

# generate new versions
#pandoc -s -S -f markdown+pipe_tables+footnotes -c test.css _source/*.md  -o downloads/$SLUG.html
pandoc --latex-engine=xelatex -f markdown+pipe_tables+footnotes _source/*.md  -o downloads/$SLUG.pdf
pandoc -S --epub-cover-image=assets/cover.jpg --epub-metadata=_downloads/epub/metadata.yml -f markdown+pipe_tables+footnotes _source/*.md  -o downloads/$SLUG.epub
pandoc _source/*.md -t plain -o downloads/$SLUG.txt
pandoc sections/*.md -o downloads/$SLUG.md

# generate yml list
ls -lh downloads/* | awk '{ split($9, a, "."); print "- permalink: " $9 "\n  title: " toupper(a[2]) " (" $5 ")" ; }' > _data/downloads.yml
