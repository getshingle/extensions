# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# Embed: videos, maps and booking calendars from other websites (YouTube,
# Vimeo, Google Maps, OpenStreetMap, Calendly …) on your pages. They load only
# when a visitor presses the button, so nothing comes from those websites, and
# they set no cookies, before the visitor wants it.
#   content/embed/_index.html     marks the folder; it is not a page
#   content/embed/studio-tour.txt one embed → {{EMBED_STUDIO_TOUR}}
# Fields: link (the address of the video, map or calendar, or the embed code
# the website gives you), title, and optionally height (in pixels), button,
# open and note to change the texts. Text below the header is a caption.

# The address to show, the address to open in a new tab, the kind and the website.
embed_source() {   # embed_source <link or embed code>
  local link=$1 id=''
  if [[ $link == *'<iframe'* && $link =~ src=\"([^\"]+)\" ]]; then link=${BASH_REMATCH[1]} link=${link//&amp;/&}; fi
  EMBED_SRC=$link EMBED_OPEN=$link kind=page height=600 site=${link#*://} site=${site%%/*} site=${site#www.}
  case $link in
    *youtube.com/watch*v=*) id=${link#*v=} ;;
    *youtu.be/*) id=${link#*youtu.be/} ;;
    *youtube.com/shorts/* | *youtube.com/embed/* | *youtube-nocookie.com/embed/*) id=${link##*/} ;;
  esac
  id=${id%%[?&#]*}
  if [[ -n $id ]]; then
    EMBED_SRC="https://www.youtube-nocookie.com/embed/$id?autoplay=1" EMBED_OPEN="https://www.youtube.com/watch?v=$id"
    kind=video site=YouTube
  elif [[ $link =~ vimeo\.com/(video/)?([0-9]+) ]]; then
    id=${BASH_REMATCH[2]}
    EMBED_SRC="https://player.vimeo.com/video/$id?dnt=1&autoplay=1" EMBED_OPEN="https://vimeo.com/$id"
    kind=video site=Vimeo
  elif [[ $link == *google.*/maps/embed* ]]; then
    kind=map site='Google Maps'
  elif [[ $link == *openstreetmap.org/export/embed* ]]; then
    kind=map site=OpenStreetMap
    if [[ $link =~ marker=([-0-9.]+)(%2C|,)([-0-9.]+) ]]; then
      EMBED_OPEN="https://www.openstreetmap.org/?mlat=${BASH_REMATCH[1]}&mlon=${BASH_REMATCH[3]}#map=17/${BASH_REMATCH[1]}/${BASH_REMATCH[3]}"
    fi
  elif [[ $link == *calendly.com/* || $link == *cal.com/* ]]; then
    kind=booking height=700
    [[ $link == *calendly.com/* ]] && site=Calendly || site=Cal.com
  fi
}

build() {
  local src=content/embed file base key kind height site example=''
  [[ -d $src ]] || return 0
  for file in "$src"/*; do
    base=${file##*/} base=${base%.*}
    [[ $base == _* || -d $file ]] && continue
    case $file in *.txt | *.html | *.md) ;; *) continue ;; esac
    read_file "$file"
    if [[ -z $FM_link ]]; then
      echo "  embed: $file has no link, so there is nothing to show." >&2
      continue
    fi
    embed_source "$FM_link"
    case $kind in
      video) EMBED_STYLE='aspect-ratio: 16 / 9' EMBED_BUTTON='Play the video' EMBED_LINK="Watch on $site"
             EMBED_NOTE="The video loads from $site when you press play." ;;
      map) EMBED_STYLE='aspect-ratio: 4 / 3' EMBED_BUTTON='Show the map' EMBED_LINK="Open in $site"
           EMBED_NOTE="The map loads from $site when you press the button." ;;
      booking) EMBED_STYLE="height: ${height}px" EMBED_BUTTON='Show the booking calendar' EMBED_LINK='Open the booking page'
               EMBED_NOTE="The calendar loads from $site when you press the button." ;;
      *) EMBED_STYLE="height: ${height}px" EMBED_BUTTON='Show it here' EMBED_LINK="Open $site"
         EMBED_NOTE="It loads from $site when you press the button." ;;
    esac
    [[ $FM_height =~ ^[0-9]+$ ]] && EMBED_STYLE="height: ${FM_height}px"
    for key in button:EMBED_BUTTON open:EMBED_LINK note:EMBED_NOTE; do
      kind=FM_${key%%:*}
      [[ -n ${!kind} ]] && printf -v "${key#*:}" '%s' "${!kind}"
    done
    html "$EMBED_SRC"; EMBED_SRC=$REPLY
    html "$EMBED_OPEN"; EMBED_OPEN=$REPLY
    html "${FM_title:-$EMBED_LINK}"; EMBED_TITLE=$REPLY
    html "$EMBED_BUTTON"; EMBED_BUTTON=$REPLY
    html "$EMBED_LINK"; EMBED_LINK=$REPLY
    html "$EMBED_NOTE"; EMBED_NOTE=$REPLY
    EMBED_CAPTION=''
    [[ $BODY == *[![:space:]]* ]] && { content_html "$file"; EMBED_CAPTION=$REPLY; }
    upper "$base"; key=EMBED_$(printf '%s' "$REPLY" | tr -cs 'A-Z0-9' '_'); key=${key%_}
    template embed embed.html; render "$REPLY"
    printf -v "$key" '%s' "$REPLY"
    [[ -n $example ]] || example="$file, put {{$key}}"
  done
  [[ -n $example ]] && ! grep -rqs --exclude-dir=embed '{{EMBED_' content templates &&
    echo "  embed: to show $example into a page"
  unset EMBED_SRC EMBED_OPEN EMBED_STYLE EMBED_TITLE EMBED_BUTTON EMBED_LINK EMBED_NOTE EMBED_CAPTION
  return 0
}
