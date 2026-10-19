# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# Portfolio: projects in content/portfolio/, in the order of their numbers,
# each with a case study page ("pages: false" in _index.html for a plain list).
#   content/portfolio/001_my-project/index.html + cover.jpg
#   content/portfolio/002_small-project.html
MENU_LINK="Projects"

build() {
  LIST_SORT=asc LIST_IMAGE_FILE=cover
  collection
}

item_hook() {
  [[ -n $ITEM_IMAGE ]] || ITEM_COVER_ALT=''
  # "https://www.example.com/" is shown as "example.com".
  ITEM_WEBSITE_TEXT=${ITEM_WEBSITE#*://} ITEM_WEBSITE_TEXT=${ITEM_WEBSITE_TEXT#www.}
  ITEM_WEBSITE_TEXT=${ITEM_WEBSITE_TEXT%/}
}
