# Careers extension

A careers page with your job openings and the story of working with you, and a
page for each position. Open positions show up in Google's job search.

## Install

1. Copy the `careers` folder into the `extensions` folder of your website,
   and `collection.sh` and `collection.css` straight into `extensions` too
   (the download has all three; replacing older copies is fine).
2. Run `bash build.sh`.

The first build puts examples in `content/careers/` and adds "Careers" to the
menu in `site.conf`. Change or replace the examples; this file explains every
field.

**Switch it off:** rename the folder to `_careers` and delete its line in `MENU`.

**Remove the menu link only:** delete its line in `MENU`; it does not come back.

## A position

```
content/careers/001_project-architect.html   → /careers/project-architect/
```

The number sets the order on the careers page.

```
---
title: Project architect
summary: One or two sentences for the careers page and link previews.
location: Riverton
type: Full-time
workplace: Hybrid
status: open
posted: 2026-10-01
deadline: 2026-11-30
apply: jobs@example.com
---
<p>The job description, in HTML.</p>
```

| Field | |
| --- | --- |
| `type` | Full-time, Part-time, Contract, Internship or Temporary |
| `workplace` | On-site, Hybrid or Remote |
| `status` | `open`, or `closed` to keep it listed as filled, without the apply button |
| `posted`, `deadline` | Dates such as 2026-11-30 |
| `apply` | An email address or a link to a form; without it, `EMAIL` from `site.conf` |

To remove a position completely, delete its file.

## The careers page

`content/careers/_index.html`: `title`, `eyebrow`, `description`, and below
them the text about working with you, shown under the positions.

## Change the look

Copy a file from `extensions/careers/templates/` (`list.html`, `card.html`,
`item.html`, `schema.json`) to `templates/careers/` in your website and edit the
copy. Your copy wins, and updating the extension does not overwrite it.
