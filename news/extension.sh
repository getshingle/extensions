# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# News: short announcements in content/news/, newest first, with a feed.
#   content/news/2026-10-01_new-office/index.html + cover.jpg   with a picture
#   content/news/2026-10-01_new-office.html                     without

# Needs extensions/collection.sh and collection.css, the list code that blog,
# news, team, careers and portfolio share. If they are missing, say where they go.
if [[ ! -f extensions/collection.sh || ! -f extensions/collection.css ]]; then
  echo "The news extension needs two more files: collection.sh and collection.css." >&2
  echo "They are in extension-news.zip, next to the news folder." >&2
  echo "Put them straight into extensions/, next to the news folder (not inside it):" >&2
  echo "  extensions/collection.sh" >&2
  echo "  extensions/collection.css" >&2
  echo "Download: https://getshingle.github.io/downloads/extension-news.zip" >&2
  exit 1
fi

MENU_LINK="News"

build() {
  LIST_SORT=desc LIST_PER_PAGE=20 LIST_FEED=true LIST_IMAGE_FILE=cover
  collection
}

item_hook() {
  [[ -n $ITEM_IMAGE ]] || ITEM_COVER_ALT=''
}
