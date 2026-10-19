# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# Markdown: write pages, posts and other entries in Markdown (.md) instead of
# HTML. Needs the program cmark-gfm (or cmark) on your computer.

MARKDOWN_TOOL=(cmark-gfm --unsafe --smart -e table -e strikethrough -e autolink)
command -v cmark-gfm >/dev/null || MARKDOWN_TOOL=(cmark --unsafe --smart)

# Markdown to HTML. A picture alone on its line becomes a <figure>; its title
# is the caption: ![What it shows](photo.jpg "The caption")
markdown() {
  REPLY=''
  [[ $1 == *[![:space:]]* ]] || return 0
  if ! command -v "${MARKDOWN_TOOL[0]}" >/dev/null; then
    echo "The markdown extension needs the program cmark-gfm. Install it:" >&2
    echo "  macOS:          brew install cmark-gfm" >&2
    echo "  Debian, Ubuntu: sudo apt install cmark-gfm" >&2
    echo "  Windows:        see extensions/markdown/README.md" >&2
    echo "Or write your pages in .html and remove extensions/markdown." >&2
    exit 1
  fi
  REPLY=$("${MARKDOWN_TOOL[@]}" <<<"$1" | sed -E \
    -e 's~^<p><img src="([^"]*)" alt="([^"]*)" title="([^"]*)" /></p>$~<figure><img src="\1" alt="\2" loading="lazy"><figcaption>\3</figcaption></figure>~' \
    -e 's~^<p><img src="([^"]*)" alt="([^"]*)" /></p>$~<figure><img src="\1" alt="\2" loading="lazy"></figure>~' \
    -e 's~ />~>~g')
  # A page of its own (not a blog post or another extension's entry) gets
  # its title and description on top. build_pages is the function that asked.
  if [[ ${FUNCNAME[2]} == build_pages ]]; then
    PAGE_BODY=$REPLY
    template markdown page.html; render "$REPLY"
  fi
}
