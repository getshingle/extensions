# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# Business: your opening hours for your pages, and your business details for
# Google (structured data on the home page). Everything is in
# content/business/_index.html, which is not a page itself.
#   {{OPENING_HOURS}}        a table of your hours, for a page such as contact
#   {{OPENING_HOURS_TEXT}}   the same in one line, for example for FOOTER_TEXT
#   {{MAP_URL}}              a link to your place on a map

# The same as json in collection.sh, for websites without it.
declare -F json >/dev/null || json() {
  REPLY=${1//\\/\\\\}; REPLY=${REPLY//\"/\\\"}; REPLY=${REPLY//$'\t'/ }
  REPLY=${REPLY//$'\r'/}; REPLY=${REPLY//$'\n'/\\n}; REPLY=${REPLY//<\//<\\/}
}

# "9", "9:30" or "9.30" → "09:00", "09:30". Empty for anything else.
business_time() {
  local t=${1//[[:space:]]/}
  t=${t/./:}
  [[ $t == *:* ]] || t=$t:00
  [[ $t == ?:* ]] && t=0$t
  [[ $t =~ ^[0-2][0-9]:[0-5][0-9]$ ]] && REPLY=$t || REPLY=''
}

build() {
  local file value text n i start end range from to type key parts=() hours=() times=() days=() rows='' line=''
  local names=(monday tuesday wednesday thursday friday saturday sunday)
  local schema=(Monday Tuesday Wednesday Thursday Friday Saturday Sunday)
  OPENING_HOURS='' OPENING_HOURS_TEXT='' BUSINESS_SCHEMA=''
  [[ -d content/business ]] || return 0
  for file in content/business/_index.*; do read_file "$file"; done
  [[ ${#DAYS[@]} -eq 7 ]] || DAYS=(Monday Tuesday Wednesday Thursday Friday Saturday Sunday)

  # The hours of each day as written, "-" shown as "–"; "closed" or empty is closed.
  for (( n = 0; n < 7; n++ )); do
    value=FM_${names[n]}; value=${!value}
    [[ $value == [Cc]losed || -z $value ]] && value=Closed
    hours[n]=${value//-/–}
  done

  # Days in a row with the same hours share a line: Monday–Friday 9:00–17:30.
  for (( start = 0; start < 7; start = end + 1 )); do
    end=$start
    while (( end < 6 )) && [[ ${hours[end + 1]} == "${hours[start]}" ]]; do end=$(( end + 1 )); done
    text=${DAYS[start]}; (( end > start )) && text+="–${DAYS[end]}"
    html "$text"; text=$REPLY; html "${hours[start]}"
    rows+="  <tr><th scope=\"row\">$text</th><td>$REPLY</td></tr>"$'\n'
    [[ ${hours[start]} == *[0-9]* ]] && line+="${line:+ · }$text $REPLY"
  done
  if [[ $line ]]; then
    OPENING_HOURS="<table class=\"hours\">"$'\n'"$rows</table>"
    html "$FM_hours_note"
    [[ -n $REPLY ]] && OPENING_HOURS+=$'\n'"<p class=\"hours-note\">$REPLY</p>"
    OPENING_HOURS_TEXT=$line
  fi

  # A link to the map: "map" from the header, or a search for ADDRESS.
  if [[ -n $FM_map ]]; then
    html "$FM_map"; MAP_URL=$REPLY
  elif [[ -n $ADDRESS ]]; then
    value=${ADDRESS//%/%25} value=${value//&/%26} value=${value//+/%2B} value=${value//#/%23}
    value=${value//\?/%3F} value=${value// /+}
    html "$value"; MAP_URL="https://www.google.com/maps/search/?api=1&amp;query=$REPLY"
  fi

  # Structured data for search engines: each opening time with its days.
  for (( n = 0; n < 7; n++ )); do
    value=FM_${names[n]}; value=${!value}
    [[ $value == *[0-9]* ]] || continue
    IFS=',' read -ra parts <<<"$value"
    for range in "${parts[@]}"; do
      range=${range//–/-}
      business_time "${range%%-*}"; from=$REPLY
      business_time "${range#*-}"; to=$REPLY
      [[ -n $from && -n $to ]] || continue
      for (( i = 0; i < ${#times[@]}; i++ )); do [[ ${times[i]} == "$from-$to" ]] && break; done
      times[i]=$from-$to days[i]+="${days[i]:+, }\"${schema[n]}\""
    done
  done

  type=${FM_type:-LocalBusiness}
  if [[ ! $type =~ ^[A-Za-z]+$ ]]; then
    echo "  business: \"type: $type\" is not a type search engines know; using LocalBusiness. See extensions/business/README.md." >&2
    type=LocalBusiness
  fi
  parts=("\"@context\": \"https://schema.org\"" "\"@type\": \"$type\"")
  json "$SITE_NAME"; parts+=("\"name\": \"$REPLY\"")
  json "$SITE_DESCRIPTION"; [[ -n $REPLY ]] && parts+=("\"description\": \"$REPLY\"")
  parts+=("\"url\": \"$SITE_URL/\"")
  for value in share.png share.jpg; do
    [[ -f static/img/$value ]] && { parts+=("\"image\": \"$SITE_URL/img/$value\""); break; }
  done
  json "$PHONE_NUMBER"; [[ -n $REPLY ]] && parts+=("\"telephone\": \"$REPLY\"")
  json "$FM_price_range"; [[ -n $REPLY ]] && parts+=("\"priceRange\": \"$REPLY\"")
  if [[ -n $FM_street$FM_city ]]; then
    value="\"@type\": \"PostalAddress\""
    for key in street:streetAddress postal_code:postalCode city:addressLocality region:addressRegion country:addressCountry; do
      text=FM_${key%%:*}; json "${!text}"
      [[ -n $REPLY ]] && value+=", \"${key#*:}\": \"$REPLY\""
    done
    parts+=("\"address\": { $value }")
  elif [[ -n $ADDRESS ]]; then
    json "$ADDRESS"; parts+=("\"address\": \"$REPLY\"")
  fi
  if [[ $FM_latitude =~ ^-?[0-9.]+$ && $FM_longitude =~ ^-?[0-9.]+$ ]]; then
    parts+=("\"geo\": { \"@type\": \"GeoCoordinates\", \"latitude\": $FM_latitude, \"longitude\": $FM_longitude }")
  fi
  json "$FM_map"; [[ -n $REPLY ]] && parts+=("\"hasMap\": \"$REPLY\"")
  if (( ${#times[@]} )); then
    value=''
    for (( i = 0; i < ${#times[@]}; i++ )); do
      value+="${value:+,}"$'\n'"    { \"@type\": \"OpeningHoursSpecification\", \"dayOfWeek\": [${days[i]}], \"opens\": \"${times[i]%-*}\", \"closes\": \"${times[i]#*-}\" }"
    done
    parts+=("\"openingHoursSpecification\": [$value"$'\n'"  ]")
  fi
  value=''
  for line in "${SOCIAL[@]}"; do
    [[ ${line#*|} == http* ]] || continue
    json "${line#*|}"; value+="${value:+, }\"$REPLY\""
  done
  [[ -n $value ]] && parts+=("\"sameAs\": [$value]")

  value=''
  for line in "${parts[@]}"; do value+="${value:+,}"$'\n'"  $line"; done
  BUSINESS_SCHEMA="<script type=\"application/ld+json\">"$'\n'"{$value"$'\n'"}"$'\n'"</script>"
}

# The structured data goes into the home page, just before </head>.
finish() {
  [[ -n $BUSINESS_SCHEMA && -f dist/index.html ]] || return 0
  SCHEMA=$BUSINESS_SCHEMA awk '/<\/head>/ && !done { print "  " ENVIRON["SCHEMA"]; done = 1 } { print }' \
    dist/index.html > dist/index.html.new
  mv dist/index.html.new dist/index.html
}
