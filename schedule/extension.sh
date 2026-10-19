# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# Schedule: a weekly timetable at /schedule/, and on any page with {{SCHEDULE}}.
# One text file per day (or per room, group …), in the order of their numbers.
#   content/schedule/_index.html     the page's title and text
#   content/schedule/1_monday.txt    a day: a header with its title, then one line per class
# A class is its time, name and any details, separated by |:
#   18:00–19:00 | Vinyasa flow | Maja | All levels
# A line without | is a note for that day, such as "Closed".

MENU_LINK="Schedule"

schedule_trim() {   # remove spaces at both ends
  REPLY=${1#"${1%%[![:space:]]*}"}
  REPLY=${REPLY%"${REPLY##*[![:space:]]}"}
}

# One day's lines as HTML.
schedule_day() {   # schedule_day <text>
  local line parts part n out=''
  while IFS= read -r line; do
    line=${line%$'\r'}
    [[ $line == *[![:space:]]* ]] || continue
    schedule_trim "$line"; line=$REPLY
    if [[ $line != *'|'* ]]; then
      html "$line"; out+="<li class=\"note\">$REPLY</li>"$'\n'
      continue
    fi
    IFS='|' read -ra parts <<<"$line"
    schedule_trim "${parts[0]}"; html "${REPLY//-/–}"; SLOT_TIME=$REPLY
    schedule_trim "${parts[1]}"; html "$REPLY"; SLOT_TITLE=$REPLY
    SLOT_DETAILS=''
    for (( n = 2; n < ${#parts[@]}; n++ )); do
      schedule_trim "${parts[n]}"; html "$REPLY"
      [[ -n $REPLY ]] && SLOT_DETAILS+="${SLOT_DETAILS:+ · }$REPLY"
    done
    template "$EXT" class.html; render "$REPLY"; out+=$REPLY
  done <<<"$1"
  REPLY=$out
}

build() {
  local src=content/$EXT file base days=''
  SCHEDULE=''
  [[ -d $src ]] || return 0
  unset "${!LIST_@}"
  for file in "$src"/_index.*; do
    read_file "$file"; export_fields LIST
    content_html "$file"; LIST_BODY=$REPLY
  done
  LIST_TITLE=${LIST_TITLE:-Schedule}

  for file in "$src"/*; do
    base=${file##*/} base=${base%.*}
    [[ $base == _* || -d $file ]] && continue
    case $file in *.txt | *.html | *.md) ;; *) continue ;; esac
    read_file "$file"
    [[ $FM_draft == true && ! $PREVIEW ]] && continue
    DAY_ID=${base#*_}
    html "${FM_title:-$DAY_ID}"; DAY_TITLE=$REPLY
    schedule_day "$BODY"; DAY_CLASSES=$REPLY
    template "$EXT" day.html; render "$REPLY"; days+=$REPLY
  done
  [[ -n $days ]] && SCHEDULE="<div class=\"week\">"$'\n'"$days</div>"
  LIST_ITEMS=$SCHEDULE

  template "$EXT" page.html; render "$REPLY"
  unset "${!PAGE_@}"
  PAGE_URL=/$EXT/ PAGE_TITLE=$LIST_TITLE PAGE_DESCRIPTION=$LIST_DESCRIPTION
  write_page "$REPLY"
  unset "${!LIST_@}" "${!DAY_@}" "${!SLOT_@}"
}
