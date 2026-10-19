# Services extension

What you offer, as cards on a services page and a page for each service with
its price, duration and a button to book. `{{SERVICES}}` shows the cards on
any other page, such as your home page.

Good for treatments, classes and courses, rooms, packages, practice areas or
anything else you sell or do.

## Install

1. Copy the `services` folder into the `extensions` folder of your website,
   and `collection.sh` and `collection.css` straight into `extensions` too
   (the download has all three; replacing older copies is fine).
2. Run `bash build.sh`.

The first build puts examples in `content/services/` and adds "Services" to
the menu in `site.conf` (unless it is there already). From then on
`/services/` comes from `content/services/`: if you also have a page
`content/services.html`, the build tells you that it is no longer used.
Move what you want to keep from it into `content/services/_index.html`.

**Switch it off:** rename the folder to `_services`.

## A service

```
content/services/01_new-homes/index.html   → /services/new-homes/
content/services/01_new-homes/cover.jpg    its picture (3:2 works well)
content/services/02_advice.html            without a picture: one file is enough
```

The number sets the order.

```
---
title: Facial treatment
summary: One or two sentences for the card and for link previews.
price: €65
duration: 60 minutes
book: https://cal.com/…
book_label: Book a time
cover_alt: What the picture shows
---
<p>More about it, in HTML: what happens, what is included, who it is for.</p>
```

| Field | |
| --- | --- |
| `summary` | One or two sentences for the card and link previews |
| `book` | Where the button goes: a booking page, `/contact/` or an email link. Without it, the same place as the button in the menu |
| `book_label` | The text on the button. Without it, the menu button's text |
| `cover_alt` | What the picture shows, for people who cannot see it |
| `draft` | `true` keeps it off the website |
| anything else | A fact under the title: `price: €65` shows as "Price €65", `class_size: 8 people` as "Class size 8 people". The first two also go on the card |

Facts can be in any language: `cena: 65 €` shows as "Cena 65 €".

**In Markdown:** with the [markdown extension](../markdown/), write the text
in Markdown and name the file `.md` (`index.md` in a folder).

## The services page

`content/services/_index.html` holds its `title`, `eyebrow`, `description`,
and text that appears above the cards.

## On other pages

`{{SERVICES}}` shows all the cards, for example on the home page:

```
<section>
  <h2>What we do</h2>
  {{SERVICES}}
</section>
```

## Change the look

Copy a file from `extensions/services/templates/` (`list.html`, `card.html`,
`item.html`, `schema.json`) to `templates/services/` in your website and edit
the copy. Your copy wins, and updating the extension does not overwrite it.
