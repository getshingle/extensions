# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# ==============================================================================
# collection.sh: shared code for extensions that list entries: blog, news,
# team, careers, portfolio, services, testimonials, gallery and pricing. It
# comes with each of them.
#
#   content/<name>/_index.html                 the list page and its settings
#   content/<name>/<key>_<slug>.html           an entry
#   content/<name>/<key>_<slug>/index.html     an entry with its pictures
#
# The key sorts the entries: 001, 002 … or a date such as 2026-10-18 (add _01,
# _02 for several on one day). The slug is the address: /<name>/<slug>/.
#
# An extension's build() sets LIST_* defaults and calls collection. Settings in
# _index.html win: per_page, sort, pages, feed. An optional item_hook runs for
# every entry before its templates are rendered; $file is the entry's file.
# Afterwards COLLECTION_CARDS holds every card, for values that pages can
# show, such as {{SERVICES}}.
# ==============================================================================

[[ ${#MONTHS[@]} -eq 12 ]] || MONTHS=(January February March April May June July August September October November December)
TODAY=$(date +%Y-%m-%d)
DATE='^([0-9]{4})-([0-9]{2})-([0-9]{2})'

json() {   # escape text for a JSON string
  REPLY=${1//\\/\\\\}; REPLY=${REPLY//\"/\\\"}; REPLY=${REPLY//$'\t'/ }
  REPLY=${REPLY//$'\r'/}; REPLY=${REPLY//$'\n'/\\n}; REPLY=${REPLY//<\//<\\/}
}

date_text() {   # 2026-10-18 → "18 October 2026"
  REPLY="$(( 10#${1:8:2} )) ${MONTHS[10#${1:5:2} - 1]} ${1:0:4}"
}

field() {   # field <file> <key>: one header value from another file
  local line n=0
  REPLY=''
  while IFS= read -r line && (( n < 2 )); do
    line=${line%$'\r'}
    [[ $line == --- || $line == '<!--' || $line == '-->' ]] && { n=$(( n + 1 )); continue; }
    [[ $line == "$2:"* ]] && { REPLY=${line#"$2:"}; REPLY=${REPLY# }; return 0; }
  done < "$1"
  return 0
}

# Build content/$EXT/: a page per entry, the list page(s) and an optional feed.
collection() {
  local src=content/$EXT entry base file p per pages total slugs=' '
  local items=() cards=() entries='' updated=''
  COLLECTION_CARDS=()
  [[ -d $src ]] || return 0

  # The list page's header (_index.html) and its settings.
  for file in "$src"/_index.*; do
    read_file "$file"; export_fields LIST
    content_html "$file"; LIST_BODY=$REPLY
  done
  LIST_URL=/$EXT/
  upper "${EXT:0:1}"; LIST_TITLE=${LIST_TITLE:-$REPLY${EXT:1}}
  [[ $LIST_PAGES == false ]] && LIST_FEED=''          # only a list: no pages, no feed
  [[ $LIST_FEED == true ]] && LIST_HEAD="<link rel=\"alternate\" type=\"application/atom+xml\" title=\"$LIST_TITLE\" href=\"${LIST_URL}feed.xml\">"

  # Entries: file.html, file.md, folder/index.html or folder/index.md.
  for entry in "$src"/*; do
    base=${entry##*/}
    [[ $base == _* ]] && continue
    if [[ -f $entry/index.html ]]; then file=$entry/index.html
    elif [[ -f $entry/index.md ]]; then file=$entry/index.md
    elif [[ $base == *.html || $base == *.md ]]; then file=$entry base=${base%.*}
    else continue
    fi
    items+=("$base|$file")
  done
  if [[ $LIST_SORT == desc ]]; then
    for (( p = ${#items[@]} - 1; p >= 0; p-- )); do cards+=("${items[p]}"); done
    items=("${cards[@]}") cards=()
  fi

  for entry in "${items[@]}"; do
    collection_item "${entry%%|*}" "${entry#*|}" || continue
    if [[ $slugs == *" $ITEM_SLUG "* ]]; then
      echo "Two entries in $src/ have the address $ITEM_URL; rename one." >&2
      exit 1
    fi
    slugs+="$ITEM_SLUG "
    template "$EXT" card.html; render "$REPLY"; cards+=("$REPLY")
    if [[ $LIST_FEED == true && ${#cards[@]} -le 20 ]]; then
      updated=${updated:-${ITEM_DATE:-$TODAY}}
      entries+="  <entry><title>$ITEM_TITLE</title><link href=\"$SITE_URL$ITEM_URL\"/><id>$SITE_URL$ITEM_URL</id><updated>${ITEM_DATE:-$TODAY}T00:00:00Z</updated><summary>$ITEM_SUMMARY</summary></entry>"$'\n'
    fi
  done

  COLLECTION_CARDS=("${cards[@]}")

  # List pages: /<name>/, then /<name>/page/2/ … when per_page is set.
  total=${#cards[@]} per=${LIST_PER_PAGE:-0}
  (( per > 0 )) || per=$(( total > 0 ? total : 1 ))
  pages=$(( total > 0 ? (total + per - 1) / per : 1 ))
  for (( p = 1; p <= pages; p++ )); do
    LIST_ITEMS='' PREV_URL='' NEXT_URL='' LIST_PAGER='' PAGE_NUMBER=$p PAGE_COUNT=$pages
    for entry in "${cards[@]:(p - 1) * per:per}"; do LIST_ITEMS+=$entry; done
    if (( p == 2 )); then PREV_URL=$LIST_URL; elif (( p > 2 )); then PREV_URL=${LIST_URL}page/$(( p - 1 ))/; fi
    if (( p < pages )); then NEXT_URL=${LIST_URL}page/$(( p + 1 ))/; fi
    if (( pages > 1 )); then template "$EXT" pager.html; render "$REPLY"; LIST_PAGER=$REPLY; fi
    template "$EXT" list.html; render "$REPLY"
    unset "${!PAGE_@}"
    PAGE_URL=$LIST_URL PAGE_TITLE=$LIST_TITLE PAGE_DESCRIPTION=$LIST_DESCRIPTION PAGE_HEAD=$LIST_HEAD
    if (( p > 1 )); then PAGE_URL=${LIST_URL}page/$p/ PAGE_TITLE+=" (page $p)"; fi
    write_page "$REPLY"
  done

  if [[ $LIST_FEED == true ]]; then
    html "$SITE_NAME"
    cat > "dist/$EXT/feed.xml" <<EOF
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>$LIST_TITLE · $REPLY</title>
  <link href="$SITE_URL$LIST_URL"/>
  <link rel="self" href="$SITE_URL${LIST_URL}feed.xml"/>
  <id>$SITE_URL$LIST_URL</id>
  <updated>${updated:-$TODAY}T00:00:00Z</updated>
  <author><name>$REPLY</name></author>
$entries</feed>
EOF
  fi
  unset "${!LIST_@}" "${!ITEM_@}" "${!JSON_@}"
  unset -f item_hook
}

# One entry: its own page (unless "pages: false"), and the ITEM_* values for
# its card. Returns 1 for drafts and for entries dated in the future.
collection_item() {   # collection_item <name without extension> <file>
  local base=$1 file=$2 date='' f key value
  read_file "$file"
  [[ $FM_draft == true && ! $PREVIEW ]] && return 1
  unset "${!ITEM_@}" "${!JSON_@}"
  export_fields ITEM
  ITEM_SLUG=${base##*_} && ITEM_URL=/$EXT/$ITEM_SLUG/
  ITEM_TITLE=${ITEM_TITLE:-$ITEM_SLUG} ITEM_TITLE_LINK=${ITEM_TITLE:-$ITEM_SLUG}
  [[ $LIST_PAGES == false ]] || ITEM_TITLE_LINK="<a href=\"$ITEM_URL\">$ITEM_TITLE</a>"

  # A date from the header, or from the start of the name.
  date=$FM_date
  [[ -z $date && $base =~ $DATE ]] && date=${BASH_REMATCH[0]}
  if [[ $date =~ $DATE ]]; then
    [[ $date > $TODAY && ! $PREVIEW ]] && return 1
    date_text "$date"; ITEM_DATE=$date ITEM_DATE_TEXT=$REPLY
  fi

  # A folder entry: its other files are published next to the page, and
  # cover.jpg (photo.jpg for the team, see LIST_IMAGE_FILE) is its picture.
  if [[ $file == */index.* ]]; then
    mkdir -p "dist$ITEM_URL"
    for f in "${file%/*}"/*; do [[ $f == */index.* ]] || cp -R "$f" "dist$ITEM_URL"; done
    for f in "${file%/*}/${LIST_IMAGE_FILE:-cover}".{jpg,jpeg,png,webp,avif,svg}; do
      [[ -f $f ]] && { ITEM_IMAGE=$ITEM_URL${f##*/}; break; }
    done
  fi
  [[ -z $ITEM_IMAGE || $ITEM_IMAGE == /* || $ITEM_IMAGE == http* ]] || ITEM_IMAGE=$ITEM_URL$ITEM_IMAGE

  content_html "$file"; ITEM_BODY=$REPLY

  # Values for structured data (schema.json): {{JSON_TITLE}} …
  for key in "${FM_KEYS[@]}"; do
    value=FM_$key; json "${!value}"; value=$REPLY
    upper "$key"; printf -v "JSON_$REPLY" '%s' "$value"
  done
  json "$SITE_NAME"; JSON_SITE_NAME=$REPLY
  json "$ITEM_BODY"; JSON_BODY=$REPLY
  JSON_SITE_URL=$SITE_URL JSON_URL=$SITE_URL$ITEM_URL JSON_DATE=$ITEM_DATE JSON_IMAGE=''
  [[ -n $ITEM_IMAGE ]] && JSON_IMAGE=$SITE_URL$ITEM_IMAGE

  # The extension's own additions. It can set ITEM_SCHEMA='' to leave out structured data.
  if declare -F item_hook >/dev/null; then item_hook; fi
  [[ $LIST_PAGES == false ]] && return 0
  if [[ -z ${ITEM_SCHEMA+set} && ( -f templates/$EXT/schema.json || -f extensions/$EXT/templates/schema.json ) ]]; then
    template "$EXT" schema.json; render "$REPLY"
    ITEM_SCHEMA="<script type=\"application/ld+json\">"$'\n'"$REPLY</script>"
  fi

  template "$EXT" item.html; render "$REPLY"
  unset "${!PAGE_@}"
  PAGE_URL=$ITEM_URL PAGE_TITLE=$ITEM_TITLE PAGE_TYPE=article PAGE_HEAD=$LIST_HEAD
  PAGE_DESCRIPTION=$ITEM_SUMMARY PAGE_IMAGE=$ITEM_IMAGE
  write_page "$REPLY"
}
