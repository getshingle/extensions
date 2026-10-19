# Team extension

A team page with a card for each person, and a page for each person with a
large photo, their story, contact details and social links.

## Install

1. Copy the `team` folder into the `extensions` folder of your website,
   and `collection.sh` and `collection.css` straight into `extensions` too
   (the download has all three; replacing older copies is fine).
2. Run `bash build.sh`.

The first build puts examples in `content/team/` and adds "Team" to the
menu in `site.conf`. Change or replace the examples; this file explains every
field.

**Switch it off:** rename the folder to `_team` and delete its line in `MENU`.

**Remove the menu link only:** delete its line in `MENU`; it does not come back.

## A person

```
content/team/001_anna-berg/index.html   → /team/anna-berg/, first on the team page
content/team/001_anna-berg/photo.jpg    a portrait, 4:5 (for example 800 × 1000)
content/team/004_james-okafor.html      no photo: their initials are shown
```

The number sets the order. To move someone, change their number.

```
---
title: Anna Berg
role: Founder and principal architect
summary: One sentence for the team page.
phone: +1 555 0110
mobile: +1 555 0171
email: anna@example.com
linkedin: https://www.linkedin.com/in/…
bluesky: https://bsky.app/…
---
<p>Their story, in HTML.</p>
```

Leave out any field you do not need; it disappears from the page. Email
addresses are hidden from spam bots.

**Social links:** `linkedin`, `x`, `facebook`, `instagram`, `bluesky`,
`threads`, `youtube`, `github`, `tiktok`, `mastodon`, `pinterest`, `behance`,
`whatsapp`, `website`: one for each icon in `assets/icons/`. To add a network,
add its icon there, in the same format as the others.

**In Markdown:** with the [markdown extension](../markdown/), a person can be
written in Markdown instead of HTML. Name the file `.md` instead of `.html`
(`index.md` in a folder); the header stays the same.

## The team page

`content/team/_index.html`: `title`, `eyebrow`, `description`, optional text,
`show_social` (`true` shows the social icons on the team page too, `false`
only on each person's page), and `pages: false` for a team page without a page
for each person.

## Change the look

Copy a file from `extensions/team/templates/` (`list.html`, `card.html`,
`item.html`, `schema.json`) to `templates/team/` in your website and edit the
copy. Your copy wins, and updating the extension does not overwrite it.
