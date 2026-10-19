# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# Testimonials: what your clients say, in content/testimonials/, in the order
# of their numbers. {{TESTIMONIALS}} shows the first three on any page (set
# "show" in _index.html for more); /testimonials/ shows them all.
#   content/testimonials/01_maria-lind.html                  one quote
#   content/testimonials/02_tom-baker/index.html + photo.jpg with a photo
# Fields: title (the person's name), role, rating (1 to 5).

# Needs extensions/collection.sh and collection.css, the list code that several
# extensions share. If they are missing, say where they go.
if [[ ! -f extensions/collection.sh || ! -f extensions/collection.css ]]; then
  echo "The testimonials extension needs two more files: collection.sh and collection.css." >&2
  echo "They are in extension-testimonials.zip, next to the testimonials folder." >&2
  echo "Put them straight into extensions/, next to the testimonials folder (not inside it):" >&2
  echo "  extensions/collection.sh" >&2
  echo "  extensions/collection.css" >&2
  echo "Download: https://getshingle.github.io/downloads/extension-testimonials.zip" >&2
  exit 1
fi

build() {
  local file show=3 n
  for file in content/testimonials/_index.*; do field "$file" show; [[ $REPLY =~ ^[0-9]+$ ]] && show=$REPLY; done
  LIST_SORT=asc LIST_PAGES=false LIST_IMAGE_FILE=photo
  collection
  TESTIMONIALS=''
  for (( n = 0; n < ${#COLLECTION_CARDS[@]} && n < show; n++ )); do TESTIMONIALS+=${COLLECTION_CARDS[n]}; done
  [[ -n $TESTIMONIALS ]] && TESTIMONIALS="<div class=\"cols-3 testimonials\">"$'\n'"$TESTIMONIALS</div>"
  return 0
}

item_hook() {
  local words=() stars='' n
  # Initials for people without a photo: "Maria Lind" → "ML".
  read -ra words <<<"$FM_title"
  ITEM_INITIALS=${words[0]:0:1}
  (( ${#words[@]} > 1 )) && ITEM_INITIALS+=${words[${#words[@]} - 1]:0:1}
  # "rating: 4" → ★★★★☆
  ITEM_STARS='' ITEM_RATING_TEXT=''
  if [[ $FM_rating =~ ^[1-5]$ ]]; then
    for (( n = 1; n <= 5; n++ )); do if (( n <= FM_rating )); then stars+='★'; else stars+='☆'; fi; done
    ITEM_STARS=$stars ITEM_RATING_TEXT="$FM_rating out of 5"
  fi
  return 0
}
