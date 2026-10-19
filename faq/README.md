# FAQ extension

Questions and answers on a page of their own at `/faq/`, grouped by topic,
and on any other page you like, such as your services or prices.

## Install

1. Copy the `faq` folder into the `extensions` folder of your website.
2. Run `bash build.sh`.

The first build puts examples in `content/faq/` and adds "FAQ" to the menu in
`site.conf`. Change or replace the examples.

**Switch it off:** rename the folder to `_faq` and delete its line in `MENU`.

## A question

One file per question. The number at the start sets the order:

```
content/faq/01_what-does-it-cost.html
```

```
---
title: What does an architect cost?
topic: Fees
---
<p>The answer, in HTML. It can have several paragraphs, lists and links.</p>
```

`topic` is optional. On the FAQ page, questions without a topic come first,
then each topic under its own heading. `draft: true` keeps a question off the
website.

## On other pages

Put one of these into any page in `content/`:

| | |
| --- | --- |
| `{{FAQ}}` | every question |
| `{{FAQ_FEES}}` | the questions with `topic: Fees` |
| `{{FAQ_PLANNING_PERMISSION}}` | `topic: Planning permission`: capitals, spaces become `_` |

For example, at the end of `content/services.html`:

```
<section class="narrow">
  <h2>Questions about our fees</h2>
  {{FAQ_FEES}}
</section>
```

## The FAQ page

`content/faq/_index.html` holds its `title`, `eyebrow` and `description`, and
text that appears above the questions. The page also tells search engines
that it is a list of questions and answers (FAQPage structured data).

## Change the look

Copy `page.html` or `question.html` from `extensions/faq/templates/` to
`templates/faq/` in your website and edit the copy. Your copy wins, and
updating the extension does not overwrite it.
