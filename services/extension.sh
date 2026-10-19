# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# Services: what you offer, each with its own page, in content/services/, in
# the order of their numbers. {{SERVICES}} shows the cards on any page.
#   content/services/01_new-homes/index.html + cover.jpg   → /services/new-homes/
#   content/services/02_advice.html                        without a picture
# Fields: summary, book and book_label (the button), cover_alt. Any other
# field, such as "price: From €80" or "duration: 60 minutes", is shown as a
# fact under the title, and the first two on the card.

# Needs extensions/collection.sh and collection.css, the list code that several
# extensions share. If they are missing, say where they go.
if [[ ! -f extensions/collection.sh || ! -f extensions/collection.css ]]; then
  echo "The services extension needs two more files: collection.sh and collection.css." >&2
  echo "They are in extension-services.zip, next to the services folder." >&2
  echo "Put them straight into extensions/, next to the services folder (not inside it):" >&2
  echo "  extensions/collection.sh" >&2
  echo "  extensions/collection.css" >&2
  echo "Download: https://getshingle.github.io/downloads/extension-services.zip" >&2
  exit 1
fi

MENU_LINK="Services"

build() {
  local card
  LIST_SORT=asc LIST_IMAGE_FILE=cover
  collection
  # Two or four services side by side, otherwise three.
  case ${#COLLECTION_CARDS[@]} in 2 | 4) SERVICES_COLUMNS=cols-${#COLLECTION_CARDS[@]} ;; *) SERVICES_COLUMNS=cols-3 ;; esac
  SERVICES=''
  for card in "${COLLECTION_CARDS[@]}"; do SERVICES+=$card; done
  [[ -n $SERVICES ]] && SERVICES="<div class=\"$SERVICES_COLUMNS services\">"$'\n'"$SERVICES</div>"
  return 0
}

item_hook() {
  local key value label n=0
  ITEM_FACTS='' ITEM_META=''
  [[ -n $ITEM_IMAGE ]] || ITEM_COVER_ALT=''

  # Facts: every field that is not one of the usual ones. "class_size" → "Class size".
  for key in "${FM_KEYS[@]}"; do
    case $key in title | summary | description | book | book_label | cover_alt | image | draft | date) continue ;; esac
    value=FM_$key; html "${!value}"; value=$REPLY
    [[ -n $value ]] || continue
    label=${key//_/ }; upper "${label:0:1}"; label=$REPLY${label:1}
    ITEM_FACTS+="<div><dt>$label</dt><dd>$value</dd></div>"
    (( n++ < 2 )) && ITEM_META+="<span>$value</span>"
  done

  # The button: "book" is a link (a booking page, /contact/ …); without it, the menu button's.
  ITEM_BOOK_URL=$BUTTON_URL ITEM_BOOK_LABEL=$BUTTON_LABEL ITEM_BOOK_ATTRS=''
  [[ -n $FM_book ]] && { html "$FM_book"; ITEM_BOOK_URL=$REPLY; }
  [[ -n $FM_book_label ]] && { html "$FM_book_label"; ITEM_BOOK_LABEL=$REPLY; }
  [[ $ITEM_BOOK_URL == http* ]] && ITEM_BOOK_ATTRS=' target="_blank" rel="noopener"'
  return 0
}
