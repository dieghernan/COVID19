# Project structured data

`_data/structured_data.json` holds only the project's own structured metadata.
The includes add JSON-LD on the landing page. They do not replace or normalize
Chulapa's WebSite, WebPage, Person or breadcrumb markup.

The software is described as archived R source code, not a live web application.
The MIT license applies to the code; no numbered release or publication date is
invented. The author has a stable personal identifier, separate from the theme's
project-specific author entities.

The Dataset describes only `assets/data/COVIDEsp_actual.csv`, not every data
file or the original ISCIII dataset. Its temporal coverage comes from `Fecha`;
`dateCreated` comes from the internal `tmstamp`. These are not publication dates.
No dataset license is inferred from the software license.

Build with `bundle exec jekyll build`, then run
`py -m unittest discover -s scripts -p test_structured_data.py`.
