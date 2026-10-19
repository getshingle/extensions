# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# Downloads: files to download (PDFs, forms, price lists …) at /downloads/, and
# on any page with {{DOWNLOADS}}. Put the files in content/downloads/.
#   content/downloads/price-list-2026.pdf   → "Price list 2026", PDF, its size
#   content/downloads/price-list-2026.txt   optional: a better title on the first
#                                            line, a short description below it
#   content/downloads/2_forms/…              a folder is a group with a heading: "Forms"
# A number at the start of a name, such as 1_ or 02_, sets the order and is
# not shown. The page's title and text are in content/downloads/_index.html.

MENU_LINK="Downloads"
MENU_LIST=LEGAL

# "02_price-list_2026" → "Price list 2026"
downloads_title() {
  local name=$1
  [[ $name =~ ^[0-9]+_ ]] && name=${name#*_}
  name=${name//[-_]/ }
  upper "${name:0:1}"; REPLY=$REPLY${name:1}
}

# The files in one folder as a list; the files are copied next to the page.
downloads_list() {   # downloads_list <folder>
  local file other name base title text size unit out=''
  for file in "$1"/*; do
    [[ -f $file ]] || continue
    name=${file##*/} base=${name%.*}
    [[ $name == _* || $name == .* ]] && continue
    if [[ $name == *.txt ]]; then   # the description of another file, not a download
      for other in "${file%.*}".*; do [[ $other == "$file" ]] || continue 2; done
    fi
    [[ $name =~ ^[0-9]+_ ]] && name=${name#*_}
    cp "$file" "dist/$EXT/$name"
    downloads_title "$base"; title=$REPLY text=''
    if [[ $file != *.txt && -f ${file%.*}.txt ]]; then
      { IFS= read -r title || true; text=$(tr -d '\r'); } < "${file%.*}.txt"
      title=${title%$'\r'}
    fi
    size=$(wc -c < "$file") size=${size//[[:space:]]/}
    if (( size >= 1048576 )); then
      unit=$(( size * 10 / 1048576 )); size="$(( unit / 10 )).$(( unit % 10 )) MB"
    else
      size="$(( (size + 1023) / 1024 )) KB"
    fi
    FILE_TYPE=File
    if [[ $name == *.* ]]; then upper "${name##*.}"; FILE_TYPE=$REPLY; fi
    html "$title"; FILE_TITLE=$REPLY
    html "$text"; FILE_TEXT=$REPLY
    html "$name"; FILE_URL=/$EXT/$REPLY
    FILE_SIZE=$size
    template "$EXT" file.html; render "$REPLY"; out+=$REPLY
  done
  REPLY=$out
}

build() {
  local src=content/$EXT folder title
  DOWNLOADS=''
  [[ -d $src ]] || return 0
  unset "${!LIST_@}"
  for title in "$src"/_index.*; do
    read_file "$title"; export_fields LIST
    content_html "$title"; LIST_BODY=$REPLY
  done
  LIST_TITLE=${LIST_TITLE:-Downloads}
  mkdir -p "dist/$EXT"

  downloads_list "$src"
  [[ -n $REPLY ]] && DOWNLOADS+="<ul class=\"files\">"$'\n'"$REPLY</ul>"$'\n'
  for folder in "$src"/*/; do
    folder=${folder%/}
    [[ ${folder##*/} == _* ]] && continue
    downloads_list "$folder"
    [[ -n $REPLY ]] || continue
    title=$REPLY
    downloads_title "${folder##*/}"; html "$REPLY"
    DOWNLOADS+="<h2>$REPLY</h2>"$'\n'"<ul class=\"files\">"$'\n'"$title</ul>"$'\n'
  done
  [[ -n $DOWNLOADS ]] && DOWNLOADS="<div class=\"downloads\">"$'\n'"$DOWNLOADS</div>"
  LIST_ITEMS=$DOWNLOADS

  template "$EXT" page.html; render "$REPLY"
  unset "${!PAGE_@}"
  PAGE_URL=/$EXT/ PAGE_TITLE=$LIST_TITLE PAGE_DESCRIPTION=$LIST_DESCRIPTION
  write_page "$REPLY"
  unset "${!LIST_@}" "${!FILE_@}"
}
