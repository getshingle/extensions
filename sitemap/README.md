# Sitemap extension

Adds `sitemap.xml` and `robots.txt` to your site, so search engines such as
Google find every page.

1. Copy the `sitemap` folder into the `extensions` folder of your website.
2. Set `SITE_URL` in `site.conf` to your real address, for example
   `https://www.example.com`.
3. Run `bash build.sh`.

To give search engines your own rules, put a `robots.txt` in `static/`; the
extension then leaves it as it is.
