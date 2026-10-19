# Testimonials extension

What your clients say, as quote cards with a name, a photo or initials and
an optional star rating. `{{TESTIMONIALS}}` shows the first three on any
page, such as your home page; `/testimonials/` shows them all.

## Install

1. Copy the `testimonials` folder into the `extensions` folder of your
   website, and `collection.sh` and `collection.css` straight into
   `extensions` too (the download has all three; replacing older copies is
   fine).
2. Run `bash build.sh`.
3. Put `{{TESTIMONIALS}}` where you want the quotes, for example on the home
   page:

```
<section>
  <h2>What our clients say</h2>
  {{TESTIMONIALS}}
</section>
```

The first build puts examples in `content/testimonials/`. There is no menu
link; the page `/testimonials/` is there if you want to link to it.

**Switch it off:** rename the folder to `_testimonials`.

## A testimonial

```
content/testimonials/01_maria-lind.html                one quote, with initials
content/testimonials/02_tom-baker/index.html           with a photo:
content/testimonials/02_tom-baker/photo.jpg            square, about 300 × 300
```

```
---
title: Maria Lind
role: Riverside House, Riverton
rating: 5
---
<p>What they said, in their words.</p>
```

| Field | |
| --- | --- |
| `title` | The person's name |
| `role` | Who they are: a job, a company, a project or a town |
| `rating` | 1 to 5 stars; leave it out for none |
| `draft` | `true` keeps it off the website |

Only publish what people really said, with their permission.

## Settings

`content/testimonials/_index.html` holds the page's `title`, `eyebrow` and
`description`, and `show`: how many `{{TESTIMONIALS}}` shows (3 if not set).
The number at the start of each file sets the order.

## Change the look

Copy `list.html` or `card.html` from `extensions/testimonials/templates/` to
`templates/testimonials/` in your website and edit the copy.
