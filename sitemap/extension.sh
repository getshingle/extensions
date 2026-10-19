# shellcheck shell=bash disable=SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# Sitemap: sitemap.xml and robots.txt, so search engines find every page.
# Uses SITE_URL from site.conf, so set your real address there.

finish() {
  local url
  {
    echo '<?xml version="1.0" encoding="UTF-8"?>'
    echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
    for url in "${PAGES[@]}"; do echo "  <url><loc>$SITE_URL$url</loc></url>"; done
    echo '</urlset>'
  } > dist/sitemap.xml
  [[ -f dist/robots.txt ]] || printf 'User-agent: *\nAllow: /\n\nSitemap: %s/sitemap.xml\n' "$SITE_URL" > dist/robots.txt
}
