# jekyll-book
A Jekyll and Bootstrap framework for publishing a book online in multiple formats.

This project was forked from [travist/jekyll-kickstart](https://github.com/travist/jekyll-kickstart), a nice framework for starting a clean Jekyll 
site with minimal Bootstrap CSS. Jekyll-Book extends it with a set of plugins, include files and conventions to support a book-like publication. A given set of 
Markdown files are rendered into a series of interlinked pages, and also in a single PDF (and other output files) for downloading. 

An example project: [Github repo](https://github.com/pbinkley/jekyll-book-marriage); [public site](https://www.wallandbinkley.com/rcb/works/marriage/)

## Installation

- Install Ruby if necessary (requires 2.0 or later)
- [Install Pandoc](http://pandoc.org/installing.html) (with LaTex support)
- Clone this repository
- In the repository directory, run ```bundle install``` to install the necessary gems
- Run ```jekyll s``` to start the server
- Visit the demo site at [http://127.0.0.1:4000/path/to/work/](http://127.0.0.1:4000/path/to/work/)

## Customization

### Metadata

The bibliographic metadata for the book is entered in ```_config.yml```:

```
title: Title of Book
brand: Title of Book
subtitle: Book has a subtitle
author: Mary Author
date: 1918
description: >
  Author, Title (Place: Publisher, Year)
# description_latex is included in the PDF, so it uses LaTeX formatting
description_latex: >
  Author, \textit{Title} (Place: Publisher, Year)
editor: Jim Editor
twitter: "@mytwitterhandle" # included 
license_icon: publicdomain # specified image in assets directory
license_text: "To the extent possible under law, Jim Editor has waived all copyright and related or neighboring rights to \"Title of Book\". This work is published from: Canada."
# link back to this site in PDF; or just delete this line
jb_credit_latex: "Generated with jekyll-book ¶ \\href{https://github.com/pbinkley/jekyll-book}{https://github.com/pbinkley/jekyll-book}"
# Info for CC license vcard in _includes/license.html
publisher_url: "http://www.domain.com/publisher/"
country_name: Canada
country_code : CA
```

The full citation should also be added to ```_includes/citation.html```.

### Content

Content files belong in the ```sections``` directory. They will be rendered according to the alphabetical order of file names, so they should be named appropriately.

Each file should have a YAML metadata header:

```
---
layout: section               # invokes _layouts/section.html
title: "Chapter 2: Tables"    # used in HTML head, jumbotron div, etc.
permalink: 02-chapter2.html   # name of rendered file
id: s02                       # used as id of article element, for chapter-
                              #    specific CSS
group: sections               # grouping in dropdown menus
---
```

### Download Formats

### Markdown Considerations

