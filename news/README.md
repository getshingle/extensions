# News extension

Short announcements as a dated list, newest first, and a feed at
`/news/feed.xml`.

## Install

1. Copy the `news` folder into the `extensions` folder of your website,
   and `collection.sh` and `collection.css` straight into `extensions` too
   (the download has all three; replacing older copies is fine).
2. Run `bash build.sh`.

The first build puts examples in `content/news/` and adds "News" to the
menu in `site.conf`. Change or replace the examples; this file explains every
field.

**Switch it off:** rename the folder to `_news` and delete its line in `MENU`.

**Remove the menu link only:** delete its line in `MENU`; it does not come back.

## An announcement

```
content/news/2026-10-01_new-studio/index.html        → /news/new-studio/
content/news/2026-10-01_new-studio/cover.jpg         an optional picture
content/news/2026-08-20_house-complete.html          no picture: one file is enough
```

```
---
title: We have moved to Harbour Lane
summary: One or two sentences for the news page and link previews.
cover_alt: What the picture shows
---
<p>The text, in HTML.</p>
```

| Field | |
| --- | --- |
| `title` | The headline |
| `summary` | One or two sentences for the news page and link previews |
| `cover_alt` | What the picture shows |
| `date` | Only if it differs from the date in the name |
| `draft` | `true` keeps it off the website; `bash build.sh preview` shows drafts |

## The news page

`content/news/_index.html`: `title`, `eyebrow`, `description`, optional text
below the header, and `per_page` (20 by default).

## Change the look

Copy a file from `extensions/news/templates/` (`list.html`, `card.html`,
`item.html`, `schema.json`) to `templates/news/` in your website and edit the
copy. Your copy wins, and updating the extension does not overwrite it.
