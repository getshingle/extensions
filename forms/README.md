# Forms extension

Contact, booking and quote forms for your pages. A website made of files
cannot send email by itself, so a form service receives each message and
emails it to you. Many services have a free plan for a small website.

## Install

1. Copy the `forms` folder into the `extensions` folder of your website.
2. Run `bash build.sh`. The first build puts an example contact form in
   `content/forms/`.
3. Put `{{FORM_CONTACT}}` where the form should be, for example in
   `content/contact.html`:

   ```
   <section class="narrow">
     {{FORM_CONTACT}}
   </section>
   ```
4. Connect a form service (below). Until then, the form shows a note instead
   of sending, and the build reminds you.

**Switch it off:** rename the folder to `_forms` and remove `{{FORM_CONTACT}}`.

## Connect a form service

You need the address your service gives you for your form. Put it into
`content/forms/_index.html`, after `action:`.

**Formspree** ([formspree.io](https://formspree.io)): make a free account,
create a form, and copy its address, such as `https://formspree.io/f/abcdwxyz`:

```
action: https://formspree.io/f/abcdwxyz
honeypot: _gotcha
```

**Web3Forms** ([web3forms.com](https://web3forms.com)): enter your email
address to get an access key, then:

```
action: https://api.web3forms.com/submit
honeypot: botcheck
```

and add this line to each form, with your key:

```
access_key | hidden | your-access-key
```

Any other service works the same way: its address goes after `action:`, and
its settings are `hidden` lines. Build, put the website online and send
yourself a test message. Most services ask you to confirm your address with
the first message.

The `honeypot` is a hidden field that people leave empty and spam robots fill
in, so the service can throw their messages away.

## A form

One text file per form. Its name gives its value: `contact.txt` is
`{{FORM_CONTACT}}`, `booking.txt` is `{{FORM_BOOKING}}`.

```
---
title: Send us a message
button: Send message
---
Your name | text | required
Email | email | required
Phone | tel | +1 555 0100
Topic | select | Prices, Booking, Something else
How should we answer? | radio | Email, Phone
Your message | textarea | required
I agree that you keep my message to answer it. | consent
```

One line per field: the label, the type and, separated by `|`, `required`
for a field that must be filled in, or the choices (for `select` and
`radio`), or an example shown in the empty field.

| Type | |
| --- | --- |
| `text` | One line of text |
| `email`, `tel`, `number`, `date`, `time`, `url` | Phones show the right keyboard |
| `textarea` | A larger box for a message |
| `select` | A list to choose from: `Topic \| select \| One, Two, Three` |
| `radio` | Choices shown side by side |
| `checkbox` | A box to tick |
| `consent` | A box that must be ticked, with a link to `/privacy/` if your website has it (privacy extension) |
| `hidden` | A setting for the service: `name \| hidden \| value` |

The header can have its own `title` (above the form), `button` and `action`
(for a form that goes somewhere else than the others).

## Privacy

The service stores the messages for you. Choose one you trust, mention it in
your privacy policy, and do not ask for more than you need. For sensitive
matters, such as health or legal problems, ask people to call or email you
instead of writing details into a form.

## Change the look

Copy `form.html` from `extensions/forms/templates/` to `templates/forms/` in
your website and edit the copy.
