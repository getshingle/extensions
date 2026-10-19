# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# Blog: posts in content/blog/, newest first, 12 per page, with a feed.
#   content/blog/2026-10-18_my-post/index.html + cover.jpg   a post with pictures
#   content/blog/2026-10-18_my-post.html                     a post without

# Needs extensions/collection.sh and collection.css, the list code that several
# extensions share. If they are missing, say where they go.
if [[ ! -f extensions/collection.sh || ! -f extensions/collection.css ]]; then
  echo "The blog extension needs two more files: collection.sh and collection.css." >&2
  echo "They are in extension-blog.zip, next to the blog folder." >&2
  echo "Put them straight into extensions/, next to the blog folder (not inside it):" >&2
  echo "  extensions/collection.sh" >&2
  echo "  extensions/collection.css" >&2
  echo "Download: https://getshingle.github.io/downloads/extension-blog.zip" >&2
  exit 1
fi

MENU_LINK="Blog"

build() {
  LIST_SORT=desc LIST_PER_PAGE=12 LIST_FEED=true LIST_IMAGE_FILE=cover
  collection
}

# For every post: reading time, and the author linked to the team page.
item_hook() {
  local words file
  words=$(printf '%s' "$BODY" | sed 's/<[^>]*>//g' | wc -w)
  ITEM_READ_TIME="$(( (words + 199) / 200 )) min read"
  [[ -n $ITEM_IMAGE ]] || ITEM_COVER_ALT=''
  ITEM_BYLINE='' JSON_AUTHOR="{ \"@type\": \"Organization\", \"name\": \"$JSON_SITE_NAME\" }"
  [[ -n $FM_author ]] || return 0
  # "author: anna-berg" links to /team/anna-berg/ when the team has that person.
  for file in content/team/*_"$FM_author".* content/team/*_"$FM_author"/index.*; do
    field "$file" title; html "$REPLY"
    ITEM_BYLINE="<a href=\"/team/$FM_author/\">$REPLY</a>"
    json "$REPLY"; JSON_AUTHOR="{ \"@type\": \"Person\", \"name\": \"$REPLY\", \"url\": \"$SITE_URL/team/$FM_author/\" }"
    return 0
  done
  ITEM_BYLINE="<span>$ITEM_AUTHOR</span>"
  json "$FM_author"; JSON_AUTHOR="{ \"@type\": \"Person\", \"name\": \"$REPLY\" }"
}
