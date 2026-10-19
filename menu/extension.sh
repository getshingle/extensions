# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# Menu: your menu or price list at /menu/, one text file per section, in the
# order of their numbers.
#   content/menu/_index.html        the page's title and text; "legend" explains the tags
#   content/menu/1_breakfast.txt    a section: a header with its title, then the dishes
# One dish per paragraph: name, price and tags on the first line, separated by
# |, and a description on the lines below it:
#   Eggs on sourdough | 9.50 | V
#   Two poached eggs, spinach and hollandaise.

MENU_LINK="Menu"

# One section's dishes as HTML, from the text below its header.
menu_dishes() {   # menu_dishes <text>
  local line first='' text='' out='' parts tag
  while IFS= read -r line || [[ -n $first ]]; do
    line=${line%$'\r'}
    if [[ $line == *[![:space:]]* ]]; then
      if [[ -z $first ]]; then first=$line; else text+="${text:+ }$line"; fi
      continue
    fi
    [[ -n $first ]] || continue
    # A paragraph is done: name | price | tags.
    IFS='|' read -ra parts <<<"$first"
    menu_trim "${parts[0]}"; html "$REPLY"; DISH=$REPLY
    menu_trim "${parts[1]}"; html "$REPLY"; DISH_PRICE=$REPLY
    DISH_TAGS=''
    IFS=',' read -ra parts <<<"${parts[2]}"
    for tag in "${parts[@]}"; do
      menu_trim "$tag"; html "$REPLY"
      [[ -n $REPLY ]] && DISH_TAGS+="<span class=\"tag\">$REPLY</span>"
    done
    html "$text"; DISH_TEXT=$REPLY
    template "$EXT" dish.html; render "$REPLY"; out+=$REPLY
    first='' text=''
  done <<<"$1"
  REPLY=$out
}

menu_trim() {   # remove spaces at both ends
  REPLY=${1#"${1%%[![:space:]]*}"}
  REPLY=${REPLY%"${REPLY##*[![:space:]]}"}
}

build() {
  local src=content/$EXT file base links='' sections=0
  [[ -d $src ]] || return 0
  unset "${!LIST_@}"
  for file in "$src"/_index.*; do
    read_file "$file"; export_fields LIST
    content_html "$file"; LIST_BODY=$REPLY
  done
  LIST_TITLE=${LIST_TITLE:-Menu}

  for file in "$src"/*; do
    base=${file##*/} base=${base%.*}
    [[ $base == _* || -d $file ]] && continue
    case $file in *.txt | *.html | *.md) ;; *) continue ;; esac
    read_file "$file"
    [[ $FM_draft == true && ! $PREVIEW ]] && continue
    SECTION_ID=${base#*_}
    html "${FM_title:-$SECTION_ID}"; SECTION_TITLE=$REPLY
    html "$FM_note"; SECTION_NOTE=$REPLY
    menu_dishes "$BODY"; SECTION_DISHES=$REPLY
    template "$EXT" section.html; render "$REPLY"; LIST_ITEMS+=$REPLY
    links+="<a href=\"#$SECTION_ID\">$SECTION_TITLE</a>"$'\n'
    sections=$(( sections + 1 ))
  done
  (( sections > 1 )) && LIST_SECTIONS=$links

  template "$EXT" page.html; render "$REPLY"
  unset "${!PAGE_@}"
  PAGE_URL=/$EXT/ PAGE_TITLE=$LIST_TITLE PAGE_DESCRIPTION=$LIST_DESCRIPTION
  write_page "$REPLY"
  unset "${!LIST_@}" "${!SECTION_@}" "${!DISH@}"
}
