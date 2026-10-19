# Blog extension

Articles with a cover picture, newest first, 12 to a page, and a feed for news
readers at `/blog/feed.xml`.

## Install

1. Copy the `blog` folder into the `extensions` folder of your website,
   and `collection.sh` and `collection.css` straight into `extensions` too
   (the download has all three; replacing older copies is fine).
2. Run `bash build.sh`.

The first build puts examples in `content/blog/` and adds "Blog" to the
menu in `site.conf`. Change or replace the examples; this file explains every
field.

**Switch it off:** rename the folder to `_blog` and delete its line in `MENU`.

**Remove the menu link only:** delete its line in `MENU`; it does not come back.

## A post

```
content/blog/2026-10-18_daylight-first/index.html   → /blog/daylight-first/
content/blog/2026-10-18_daylight-first/cover.jpg    the picture on the blog page
content/blog/2026-10-18_daylight-first/plan.svg     a picture in the text
content/blog/2026-08-14_short-note.html             no pictures: one file is enough
```

The name starts with the date. Two posts on one day: `2026-10-18_01_…`,
`2026-10-18_02_…`. After the last `_` comes the address: lowercase words
joined by `-`. A post dated in the future appears on the first build on or
after that day.

```
---
title: Design for daylight first
summary: One or two sentences for the blog page, search results and link previews.
tag: Performance
author: anna-berg
cover_alt: Low sun falling through a tall window across a wooden floor
---
<p>The text of the post, in HTML.</p>
<figure><img src="plan.svg" alt="What the plan shows"><figcaption>A caption</figcaption></figure>
```

| Field | |
| --- | --- |
| `title` | The headline |
| `summary` | One or two sentences for the blog page and link previews |
| `tag` | One word such as Design or Advice |
| `author` | A name, or a team member's address such as `anna-berg` to link to their page |
| `cover_alt` | What the cover picture shows, for people who cannot see it |
| `date` | Only if it differs from the date in the name |
| `draft` | `true` keeps it off the website; `bash build.sh preview` shows drafts |

Pictures: about 1600 pixels wide is plenty; save photos as JPG.

**In Markdown:** with the [markdown extension](../markdown/), a post can be
written in Markdown instead of HTML. Name the file `.md` instead of `.html`
(`index.md` in a folder); the header stays the same.

## The blog page

`content/blog/_index.html` holds its `title`, `eyebrow` (the small line above
the title), `description` and `per_page` (posts per page). Text below the
header appears above the posts.

## Change the look

Copy a file from `extensions/blog/templates/` (`list.html`, `card.html`,
`item.html`, `schema.json`) to `templates/blog/` in your website and edit the
copy. Your copy wins, and updating the extension does not overwrite it.
