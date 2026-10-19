# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# News: short announcements in content/news/, newest first, with a feed.
#   content/news/2026-10-01_new-office/index.html + cover.jpg   with a picture
#   content/news/2026-10-01_new-office.html                     without
MENU_LINK="News"

build() {
  LIST_SORT=desc LIST_PER_PAGE=20 LIST_FEED=true LIST_IMAGE_FILE=cover
  collection
}

item_hook() {
  [[ -n $ITEM_IMAGE ]] || ITEM_COVER_ALT=''
}
