# Pricing extension

Plans or packages side by side at `/pricing/`, with one that stands out and,
if you like, a switch between monthly and yearly prices. `{{PRICING}}` shows
them on any other page, such as your home page.

For software and memberships, but also for packages of a photographer, a
coach or an agency.

## Install

1. Copy the `pricing` folder into the `extensions` folder of your website,
   and `collection.sh` and `collection.css` straight into `extensions` too
   (the download has all three; replacing older copies is fine).
2. Run `bash build.sh`.

The first build puts examples in `content/pricing/` and adds "Pricing" to the
menu in `site.conf`.

**Switch it off:** rename the folder to `_pricing` and delete its line in `MENU`.

## A plan

One file per plan; the number at the start sets the order. Two to four plans
fit side by side.

```
content/pricing/1_starter.html
```

```
---
title: Studio
summary: For small teams who want to start this week.
price: €29
period: per month
price_yearly: €24
period_yearly: per month, paid yearly
featured: true
badge: Most popular
button: Start free
link: https://app.example.com/signup
---
<ul>
  <li>Up to 5 people</li>
  <li>Email support</li>
</ul>
```

| Field | |
| --- | --- |
| `price`, `period` | The price and what it is for: "per month", "once", "per person" |
| `price_yearly`, `period_yearly` | The yearly price. When one plan has it, a Monthly/Yearly switch appears above the plans |
| `summary` | One sentence under the name |
| `featured` | `true` gives the plan a frame and a filled button |
| `badge` | A label above its name, such as "Most popular" |
| `button`, `link` | The button's text and where it goes; without them, the menu button's |

The list below the header is the plan's features, each with a check mark.

## The pricing page

`content/pricing/_index.html` holds its `title`, `eyebrow`, `description`,
the labels of the switch (`monthly: Monthly`, `yearly: Yearly, 2 months
free`), and text below the plans, such as "All prices include tax" or
`{{FAQ}}` with the [FAQ extension](../faq/).

## Change the look

Copy `list.html` or `card.html` from `extensions/pricing/templates/` to
`templates/pricing/` in your website and edit the copy.
