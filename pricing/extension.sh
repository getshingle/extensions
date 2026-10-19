# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# Pricing: plans or packages side by side at /pricing/, and on any page with
# {{PRICING}}. One file per plan in content/pricing/, in the order of their numbers.
#   content/pricing/1_basic.html    a plan: header fields, then its features as a list
# Fields: price and period ("€29", "per month"), price_yearly and period_yearly
# for a monthly/yearly switch, summary, button and link, featured: true and
# badge ("Most popular") for the plan to stand out.

# Needs extensions/collection.sh and collection.css, the list code that several
# extensions share. If they are missing, say where they go.
if [[ ! -f extensions/collection.sh || ! -f extensions/collection.css ]]; then
  echo "The pricing extension needs two more files: collection.sh and collection.css." >&2
  echo "They are in extension-pricing.zip, next to the pricing folder." >&2
  echo "Put them straight into extensions/, next to the pricing folder (not inside it):" >&2
  echo "  extensions/collection.sh" >&2
  echo "  extensions/collection.css" >&2
  echo "Download: https://getshingle.github.io/downloads/extension-pricing.zip" >&2
  exit 1
fi

MENU_LINK="Pricing"

build() {
  local card cards=''
  PRICING_TOGGLE=''
  LIST_SORT=asc LIST_PAGES=false
  collection
  for card in "${COLLECTION_CARDS[@]}"; do cards+=$card; done
  PRICING=''
  [[ -n $cards ]] && PRICING="<div class=\"pricing\">"$'\n'"$PRICING_TOGGLE<div class=\"cols-3 plans\">"$'\n'"$cards</div>"$'\n'"</div>"
  return 0
}

item_hook() {
  ITEM_CLASS=plan ITEM_BUTTON_CLASS=btn
  if [[ $FM_featured == true ]]; then ITEM_CLASS='plan featured' ITEM_BUTTON_CLASS='btn primary'; fi
  ITEM_PRICE_YEARLY=${ITEM_PRICE_YEARLY:-$ITEM_PRICE} ITEM_PERIOD_YEARLY=${ITEM_PERIOD_YEARLY:-$ITEM_PERIOD}
  ITEM_BUTTON=${ITEM_BUTTON:-$BUTTON_LABEL} ITEM_LINK=${ITEM_LINK:-$BUTTON_URL} ITEM_LINK_ATTRS=''
  [[ $ITEM_LINK == http* ]] && ITEM_LINK_ATTRS=' target="_blank" rel="noopener"'

  # The first plan with a yearly price adds the monthly/yearly switch.
  if [[ -n $FM_price_yearly && -z $LIST_TOGGLE ]]; then
    LIST_TOGGLE="<fieldset class=\"billing\"><legend>Prices</legend>"
    LIST_TOGGLE+="<label><input type=\"radio\" name=\"billing\" value=\"monthly\" checked> ${LIST_MONTHLY:-Monthly}</label>"
    LIST_TOGGLE+="<label><input type=\"radio\" name=\"billing\" value=\"yearly\"> ${LIST_YEARLY:-Yearly}</label></fieldset>"
    PRICING_TOGGLE=$LIST_TOGGLE$'\n'
  fi
  return 0
}
