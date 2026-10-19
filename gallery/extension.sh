# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# Gallery: photo albums in content/gallery/, in the order of their numbers.
#   content/gallery/01_summer-wedding/index.html + photos   → /gallery/summer-wedding/
#   content/gallery/garden.jpg                               shown on /gallery/ itself
# The album's cover is cover.jpg, or else its first photo. A text file next to
# a photo, garden.txt for garden.jpg, is its caption. Photos open large with a click.

# Needs extensions/collection.sh and collection.css, the list code that several
# extensions share. If they are missing, say where they go.
if [[ ! -f extensions/collection.sh || ! -f extensions/collection.css ]]; then
  echo "The gallery extension needs two more files: collection.sh and collection.css." >&2
  echo "They are in extension-gallery.zip, next to the gallery folder." >&2
  echo "Put them straight into extensions/, next to the gallery folder (not inside it):" >&2
  echo "  extensions/collection.sh" >&2
  echo "  extensions/collection.css" >&2
  echo "Download: https://getshingle.github.io/downloads/extension-gallery.zip" >&2
  exit 1
fi

MENU_LINK="Gallery"

# The photos in a folder as a grid of links to the full pictures. Returns the
# count in GALLERY_COUNT. "summer-garden.jpg" gets the alt text "Summer garden".
gallery_photos() {   # gallery_photos <folder> <address of its copy in dist>
  local photo name caption alt out=''
  GALLERY_COUNT=0
  for photo in "$1"/*.{jpg,jpeg,png,webp,avif,gif,svg,JPG,JPEG,PNG}; do
    name=${photo##*/} name=${name%.*} caption=''
    [[ -f ${photo%.*}.txt ]] && caption=$(tr -d '\r' < "${photo%.*}.txt")
    alt=${name#[0-9][0-9]_} alt=${alt//[-_]/ }
    upper "${alt:0:1}"; alt=$REPLY${alt:1}
    [[ -n $caption ]] && alt=$caption
    html "$alt"; alt=$REPLY; html "$caption"; caption=$REPLY
    out+="  <li><figure><a href=\"$2${photo##*/}\"><img src=\"$2${photo##*/}\" alt=\"$alt\" loading=\"lazy\"></a>"
    out+="${caption:+<figcaption>$caption</figcaption>}</figure></li>"$'\n'
    GALLERY_COUNT=$(( GALLERY_COUNT + 1 ))
  done
  REPLY=${out:+<ul class=\"photos\">$'\n'$out</ul>}
}

build() {
  local src=content/gallery file
  [[ -d $src ]] || return 0
  # Photos straight in content/gallery/ go on the gallery page.
  mkdir -p dist/gallery
  for file in "$src"/*; do
    [[ -f $file && ${file##*/} != _* && $file != *.html && $file != *.md && $file != *.txt ]] && cp "$file" dist/gallery/
  done
  gallery_photos "$src" /gallery/; LIST_PHOTOS=$REPLY
  LIST_SORT=asc LIST_IMAGE_FILE=cover
  collection
}

# An album: its photos, how many, and its cover. $file is the album's index.html.
item_hook() {
  local txt
  ITEM_PHOTOS='' ITEM_COUNT='' ITEM_SCHEMA=''
  [[ $file == */index.* ]] || return 0
  gallery_photos "${file%/*}" "$ITEM_URL"
  ITEM_PHOTOS=$REPLY ITEM_COUNT="$GALLERY_COUNT photos"
  (( GALLERY_COUNT == 1 )) && ITEM_COUNT="1 photo"
  if [[ -z $ITEM_IMAGE && $REPLY =~ src=\"([^\"]*)\" ]]; then ITEM_IMAGE=${BASH_REMATCH[1]}; fi
  # Captions are part of the page, not files of their own.
  for txt in "${file%/*}"/*.txt; do rm -f "dist$ITEM_URL${txt##*/}"; done
  return 0
}
