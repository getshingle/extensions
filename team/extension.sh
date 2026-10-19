# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# Team: a page per person in content/team/, in the order of their numbers.
#   content/team/001_anna-berg/index.html + photo.jpg   → /team/anna-berg/
#   content/team/004_james-okafor.html                  no photo: initials
# Fields: phone, mobile, email, and any social network that has an icon in
# assets/icons/ (linkedin, instagram, x, website …).
MENU_LINK="Team"

build() {
  LIST_SORT=asc LIST_IMAGE_FILE=photo LIST_SHOW_SOCIAL=true
  collection
}

item_hook() {
  local key value link words=() contact='' pairs=() same=''

  # Initials for people without a photo: "Anna Berg" → "AB".
  read -ra words <<<"$FM_title"
  ITEM_INITIALS=${words[0]:0:1}
  (( ${#words[@]} > 1 )) && ITEM_INITIALS+=${words[${#words[@]} - 1]:0:1}

  for key in phone mobile email; do
    value=FM_$key
    [[ -n ${!value} ]] || continue
    if [[ $key == email ]]; then email_link "${!value}"; else phone_link "${!value}"; fi
    link=$REPLY
    upper "$key"; value=ICON_$REPLY
    contact+="<li>${!value}$link</li>"
  done
  ITEM_CONTACT=${contact:+<ul class=\"contact\">$contact</ul>}

  for key in "${FM_KEYS[@]}"; do
    value=FM_$key
    [[ ${!value} == http* ]] || continue
    pairs+=("$key|${!value}")
    json "${!value}"; same+="${same:+, }\"$REPLY\""
  done
  social_links "${pairs[@]}"
  ITEM_SOCIAL=$REPLY ITEM_CARD_SOCIAL=''
  [[ $LIST_SHOW_SOCIAL == true ]] && ITEM_CARD_SOCIAL=$ITEM_SOCIAL
  JSON_SAME_AS="[$same]"
}
