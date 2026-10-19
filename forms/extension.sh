# shellcheck shell=bash disable=SC2034,SC2153,SC2154  # values come from page headers and site.conf
# SPDX-License-Identifier: AGPL-3.0-or-later
# Forms: contact and booking forms for your pages. A website made of files
# cannot send email by itself, so a form service (such as Formspree or
# Web3Forms) receives the messages and emails them to you.
#   content/forms/_index.html    the service's address for every form ("action")
#   content/forms/contact.txt    a form, one line per field → {{FORM_CONTACT}}
# A field is its label, its type and "required", separated by |:
#   Your name | text | required
#   Topic | select | Prices, Booking, Something else
# Types: text, email, tel, number, date, time, url, textarea, select, radio,
# checkbox, consent (a required checkbox, with a link to /privacy/ if you have
# that page), and hidden (the service's settings: name | hidden | value).

forms_trim() {   # remove spaces at both ends
  REPLY=${1#"${1%%[![:space:]]*}"}
  REPLY=${REPLY%"${REPLY##*[![:space:]]}"}
}

# One form's fields as HTML. The form's name is used for the fields' ids.
forms_fields() {   # forms_fields <form name> <text>
  local line parts part label name type required options placeholder id n=0 out='' option star
  while IFS= read -r line; do
    line=${line%$'\r'}
    [[ $line == *[![:space:]]* && $line != '#'* ]] || continue
    IFS='|' read -ra parts <<<"$line"
    forms_trim "${parts[0]}"; label=$REPLY
    forms_trim "${parts[1]}"; type=${REPLY:-text}
    required='' options='' placeholder=''
    for part in "${parts[@]:2}"; do
      forms_trim "$part"
      if [[ $REPLY == required ]]; then required=' required'; elif [[ -n $REPLY ]]; then options=$REPLY; fi
    done
    n=$(( n + 1 )) id=form-$1-$n
    html "$label"; label=$REPLY name=$REPLY
    [[ $type == email ]] && name=email
    star=''; [[ -n $required ]] && star=' <span class="required" aria-hidden="true">*</span>'
    case $type in
      hidden)
        html "$options"; out+="  <input type=\"hidden\" name=\"$name\" value=\"$REPLY\">"$'\n' ;;
      textarea)
        out+="  <p><label for=\"$id\">$label$star</label><textarea id=\"$id\" name=\"$name\" rows=\"6\"$required></textarea></p>"$'\n' ;;
      select)
        out+="  <p><label for=\"$id\">$label$star</label><select id=\"$id\" name=\"$name\"$required><option value=\"\">Choose …</option>"
        IFS=',' read -ra parts <<<"$options"
        for option in "${parts[@]}"; do forms_trim "$option"; html "$REPLY"; out+="<option>$REPLY</option>"; done
        out+="</select></p>"$'\n' ;;
      radio)
        out+="  <fieldset><legend>$label$star</legend>"
        IFS=',' read -ra parts <<<"$options"
        for option in "${parts[@]}"; do
          forms_trim "$option"; html "$REPLY"
          out+="<label><input type=\"radio\" name=\"$name\" value=\"$REPLY\"$required> $REPLY</label>"
        done
        out+="</fieldset>"$'\n' ;;
      checkbox | consent)
        option=''
        if [[ $type == consent ]]; then
          required=' required' star=''
          [[ -e content/privacy || -e content/privacy.html || -e content/privacy.md ]] && option=" <a href=\"/privacy/\">Privacy policy</a>"
        fi
        out+="  <p class=\"check\"><label><input type=\"checkbox\" name=\"$name\" value=\"Yes\"$required> $label$star$option</label></p>"$'\n' ;;
      *)
        case $type in text | email | tel | number | date | time | url) ;; *) type=text ;; esac
        option=''
        [[ $type == email ]] && option=' autocomplete="email"'
        [[ $type == tel ]] && option=' autocomplete="tel"'
        [[ $type == text && $label == *[Nn]ame* ]] && option=' autocomplete="name"'
        [[ -n $options ]] && { html "$options"; option+=" placeholder=\"$REPLY\""; }
        out+="  <p><label for=\"$id\">$label$star</label><input id=\"$id\" name=\"$name\" type=\"$type\"$option$required></p>"$'\n' ;;
    esac
  done <<<"$2"
  REPLY=$out
}

build() {
  local src=content/forms file base action='' honeypot=_gotcha button=Send key
  [[ -d $src ]] || return 0
  for file in "$src"/_index.*; do
    read_file "$file"
    action=$FM_action honeypot=${FM_honeypot:-$honeypot} button=${FM_button:-$button}
  done
  for file in "$src"/*; do
    base=${file##*/} base=${base%.*}
    [[ $base == _* || -d $file ]] && continue
    case $file in *.txt | *.html | *.md) ;; *) continue ;; esac
    read_file "$file"
    html "${FM_action:-$action}"; FORM_ACTION=$REPLY FORM_ATTRS=''
    if [[ -z $FORM_ACTION ]]; then
      FORM_ACTION='#' FORM_ATTRS=' data-unconfigured'
      echo "  forms: $file has no form service yet, so it cannot send. See extensions/forms/README.md."
    fi
    html "${FM_honeypot:-$honeypot}"; FORM_HONEYPOT=$REPLY
    [[ $FORM_HONEYPOT == none ]] && FORM_HONEYPOT=''
    html "${FM_button:-$button}"; FORM_BUTTON=$REPLY
    html "$FM_title"; FORM_TITLE=$REPLY
    upper "$base"; key=FORM_$(printf '%s' "$REPLY" | tr -cs 'A-Z0-9' '_')
    key=${key%_}
    forms_fields "$(printf '%s' "$base" | tr -cs 'A-Za-z0-9' '-')" "$BODY"; FORM_FIELDS=$REPLY
    template forms form.html; render "$REPLY"
    printf -v "$key" '%s' "$REPLY"
  done
  grep -rqs --exclude-dir=forms '{{FORM_' content templates ||
    echo "  forms: to show a form, put {{FORM_CONTACT}} into a page, such as content/contact.html"
  unset FORM_ACTION FORM_ATTRS FORM_HONEYPOT FORM_BUTTON FORM_TITLE FORM_FIELDS
  return 0
}
