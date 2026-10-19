# Portfolio extension

Your projects, each with its own case study page. Or a simple list of clients
and references, without a page for each.

## Install

1. Copy the `portfolio` folder into the `extensions` folder of your website,
   and `collection.sh` and `collection.css` straight into `extensions` too
   (the download has all three; replacing older copies is fine).
2. Run `bash build.sh`.

The first build puts examples in `content/portfolio/` and adds "Projects" to the
menu in `site.conf`. Change or replace the examples; this file explains every
field.

**Switch it off:** rename the folder to `_portfolio` and delete its line in `MENU`.

**Remove the menu link only:** delete its line in `MENU`; it does not come back.

## A project

```
content/portfolio/001_riverside-house/index.html   → /portfolio/riverside-house/
content/portfolio/001_riverside-house/cover.jpg    the main picture (3:2 works well)
content/portfolio/001_riverside-house/plan.jpg     a picture in the text
content/portfolio/005_small-project.html            no pictures: one file is enough
```

The number sets the order: 001 comes first. To move a project, change its number.

```
---
title: A family home that lets the river in
client: The Lund family
year: 2026
location: Riverton
services: Architecture, interiors, planning
website: https://www.example.com/
summary: One or two sentences for the portfolio page and link previews.
cover_alt: What the cover picture shows
---
<h2>The challenge</h2>
<p>The case study, in HTML: the challenge, what you did, the result.</p>
```

Leave out any field you do not need; it disappears from the page.

**In Markdown:** with the [markdown extension](../markdown/), a project can be
written in Markdown instead of HTML. Name the file `.md` instead of `.html`
(`index.md` in a folder); the header stays the same.

## The portfolio page

`content/portfolio/_index.html`: `title`, `eyebrow`, `description`, optional
text below the header, and:

- `pages: false` shows only the list, without a page for each project. Good
  for a list of clients or references.
- `per_page: 12` splits a long list into pages.
- `sort: desc` shows the highest number first.

## Change the look

Copy a file from `extensions/portfolio/templates/` (`list.html`, `card.html`,
`item.html`, `schema.json`) to `templates/portfolio/` in your website and edit the
copy. Your copy wins, and updating the extension does not overwrite it.
