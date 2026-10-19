# Privacy extension

A privacy policy page at `/privacy/`, linked in the footer.

1. Copy the `privacy` folder into the `extensions` folder of your website.
2. Run `bash build.sh`.

The first build puts the page in `content/privacy/index.html` and adds
"Privacy policy" to `LEGAL` in `site.conf` (the links at the bottom of every
page). Edit the text in `content/privacy/index.html`: it is a sample, so adapt
it to your business and have it checked by someone who knows the law in your
country.
