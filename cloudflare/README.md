# Cloudflare extension

For sites hosted on Cloudflare Pages (or Netlify). Adds two files to your site:

- `_headers`: safe settings for browsers, and longer caching for the
  stylesheet and script
- `_redirects`: send visitors from an old address to a new one

1. Copy the `cloudflare` folder into the `extensions` folder of your website.
2. Run `bash build.sh`.

Edit the two files in `extensions/cloudflare/static/`. Other web hosts ignore
them, so they do no harm there.
