# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# Careers: a page per position in content/careers/, in the order of their numbers.
# The careers page text (why work with you, how you hire) is content/careers/_index.html.
#   content/careers/001_designer.html   → /careers/designer/
# Fields: location, type (Full-time, Part-time, Contract, Internship),
# workplace (On-site, Hybrid, Remote), status (open or closed), posted and
# deadline (2026-11-30), apply (an email address or a link; default: EMAIL).

# Needs extensions/collection.sh and collection.css, the list code that blog,
# news, team, careers and portfolio share. If they are missing, say where they go.
if [[ ! -f extensions/collection.sh || ! -f extensions/collection.css ]]; then
  echo "The careers extension needs two more files: collection.sh and collection.css." >&2
  echo "They are in extension-careers.zip, next to the careers folder." >&2
  echo "Put them straight into extensions/, next to the careers folder (not inside it):" >&2
  echo "  extensions/collection.sh" >&2
  echo "  extensions/collection.css" >&2
  echo "Download: https://getshingle.github.io/downloads/extension-careers.zip" >&2
  exit 1
fi

MENU_LINK="Careers"

build() {
  LIST_SORT=asc
  collection
}

item_hook() {
  local apply=${FM_apply:-$EMAIL_ADDRESS} subject
  ITEM_CLOSED='' ITEM_APPLY_URL='' ITEM_DEADLINE_TEXT='' JSON_EMPLOYMENT='' JSON_LOCATION_TYPE=''

  if [[ $FM_status == closed ]]; then
    ITEM_CLOSED=closed ITEM_SCHEMA=''        # closed: no apply button, not in job search
  elif [[ $apply == *@* && $apply != *://* ]]; then
    subject="Application: $FM_title"
    subject=${subject//%/%25}; subject=${subject//&/%26}; subject=${subject// /%20}
    ITEM_APPLY_URL="mailto:$apply?subject=$subject"
  else
    html "$apply"; ITEM_APPLY_URL=$REPLY
  fi
  if [[ $FM_deadline =~ $DATE ]]; then date_text "$FM_deadline"; ITEM_DEADLINE_TEXT=$REPLY; fi

  # Google's job search: the type of work, and whether it is remote.
  case $FM_type in
    [Ff]ull*) JSON_EMPLOYMENT=FULL_TIME ;;
    [Pp]art*) JSON_EMPLOYMENT=PART_TIME ;;
    [Cc]ontract* | [Ff]reelance*) JSON_EMPLOYMENT=CONTRACTOR ;;
    [Ii]ntern*) JSON_EMPLOYMENT=INTERN ;;
    [Tt]emp*) JSON_EMPLOYMENT=TEMPORARY ;;
  esac
  [[ $FM_workplace == [Rr]emote ]] && JSON_LOCATION_TYPE=TELECOMMUTE
  return 0
}
