# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# FAQ: questions and answers at /faq/, and on any page with {{FAQ}}.
#   content/faq/_index.html                    the FAQ page's title and text
#   content/faq/01_what-does-it-cost.html      a question: its title, then the answer
# A question with "topic: Fees" is listed under that topic on the FAQ page,
# and {{FAQ_FEES}} shows only the questions about fees.

MENU_LINK="FAQ"

# The same as json in collection.sh, for websites without it.
declare -F json >/dev/null || json() {
  REPLY=${1//\\/\\\\}; REPLY=${REPLY//\"/\\\"}; REPLY=${REPLY//$'\t'/ }
  REPLY=${REPLY//$'\r'/}; REPLY=${REPLY//$'\n'/\\n}; REPLY=${REPLY//<\//<\\/}
}

# "Fees and costs" → FEES_AND_COSTS, or with "lower": fees-and-costs.
faq_key() {   # faq_key <text> [lower]
  upper "$1"
  REPLY=$(printf '%s' "$REPLY" | tr -cs 'A-Z0-9' '_')
  REPLY=${REPLY#_} REPLY=${REPLY%_}
  if [[ $2 == lower ]]; then REPLY=$(printf '%s' "$REPLY" | tr 'A-Z_' 'a-z-'); fi
  return 0
}

build() {
  local src=content/$EXT file base topic key n answer loose='' schema='' page='' topics=()
  [[ -d $src ]] || return 0
  unset "${!LIST_@}" "${!FAQ_GROUP_@}"
  FAQ=''
  for file in "$src"/_index.*; do
    read_file "$file"; export_fields LIST
    content_html "$file"; LIST_BODY=$REPLY
  done
  LIST_TITLE=${LIST_TITLE:-FAQ}

  for file in "$src"/*; do
    base=${file##*/} base=${base%.*}
    [[ $base == _* || ( $file != *.html && $file != *.md ) ]] && continue
    read_file "$file"
    [[ $FM_draft == true && ! $PREVIEW ]] && continue
    html "$FM_title"; QUESTION=$REPLY QUESTION_ID=${base#*_}
    content_html "$file"; ANSWER=$REPLY
    template "$EXT" question.html; render "$REPLY"
    FAQ+=$REPLY

    # By topic, in the order the topics first appear: FAQ_GROUP_0, FAQ_GROUP_1 …
    topic=$FM_topic
    if [[ -z $topic ]]; then
      loose+=$REPLY
    else
      for (( n = 0; n < ${#topics[@]}; n++ )); do [[ ${topics[n]} == "$topic" ]] && break; done
      topics[n]=$topic key=FAQ_GROUP_$n
      printf -v "$key" '%s' "${!key}$REPLY"
    fi

    # For search engines: values such as {{PHONE}} are filled in first.
    expand "$ANSWER"; json "$REPLY"; answer=$REPLY
    json "$FM_title"
    schema+="${schema:+,}"$'\n'"    { \"@type\": \"Question\", \"name\": \"$REPLY\", \"acceptedAnswer\": { \"@type\": \"Answer\", \"text\": \"$answer\" } }"
  done

  # {{FAQ}}: every question. {{FAQ_<TOPIC>}}: the questions about one topic.
  [[ -n $FAQ ]] && FAQ="<div class=\"faq\">"$'\n'"$FAQ</div>"
  [[ -n $loose ]] && page="<div class=\"faq\">"$'\n'"$loose</div>"$'\n'
  for (( n = 0; n < ${#topics[@]}; n++ )); do
    key=FAQ_GROUP_$n
    html "${topics[n]}"; topic=$REPLY
    faq_key "${topics[n]}" lower
    page+="<h2 id=\"$REPLY\">$topic</h2>"$'\n'"<div class=\"faq\">"$'\n'"${!key}</div>"$'\n'
    faq_key "${topics[n]}"
    printf -v "FAQ_$REPLY" '%s' "<div class=\"faq\">"$'\n'"${!key}</div>"
  done
  LIST_ITEMS=$page
  [[ -n $schema ]] && LIST_SCHEMA="<script type=\"application/ld+json\">
{
  \"@context\": \"https://schema.org\",
  \"@type\": \"FAQPage\",
  \"mainEntity\": [$schema
  ]
}
</script>"

  template "$EXT" page.html; render "$REPLY"
  unset "${!PAGE_@}"
  PAGE_URL=/$EXT/ PAGE_TITLE=$LIST_TITLE PAGE_DESCRIPTION=$LIST_DESCRIPTION
  write_page "$REPLY"
  unset "${!LIST_@}" "${!FAQ_GROUP_@}" QUESTION QUESTION_ID ANSWER
}
