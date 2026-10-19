---
title: Markdown by example
description: What you type and what you get. This page is an example from the markdown extension; keep it as long as it helps, then delete the folder content/markdown.
---
This page is written in Markdown. Open `content/markdown/index.md` next to it to
see exactly what was typed. Every page and every entry (a blog post, a person on
the team, a job) can be a `.md` file instead of `.html`, with the same header at
the top between the `---` lines.

## Text

You type:

```
Leave an empty line between paragraphs.

**Bold**, *italic* and ~~crossed out~~.
```

You get:

Leave an empty line between paragraphs.

**Bold**, *italic* and ~~crossed out~~.

## Headings

```
## A heading
### A smaller heading
```

The page title comes from `title:` in the header, so headings in the text start
with two `#`.

## Links

```
[Our services](/services/)
[Write to us](mailto:hello@example.com)
Plain addresses work too: https://example.com
```

You get: [Our services](/services/), [write to us](mailto:hello@example.com).
Plain addresses work too: https://example.com

## Lists

```
- Coffee
- Tea

1. Choose a day
2. Book a table
```

You get:

- Coffee
- Tea

1. Choose a day
2. Book a table

## Pictures

Put the picture next to the `.md` file. A picture alone on its line gets the
text in quotes as its caption:

```
![A tall window with low sun across the floor](window.svg "Morning light in the studio")
```

![A tall window with low sun across the floor](window.svg "Morning light in the studio")

## Quotes

```
> They listened before they drew anything.
```

> They listened before they drew anything.

## Tables

```
| Day             | Open          |
| --------------- | ------------- |
| Monday – Friday | 9:00 – 17:30  |
| Saturday        | 10:00 – 14:00 |
```

| Day             | Open          |
| --------------- | ------------- |
| Monday – Friday | 9:00 – 17:30  |
| Saturday        | 10:00 – 14:00 |

## Your contact details

The values from `site.conf` work as in HTML pages. Write two curly brackets,
the name in capitals and two closing brackets, as this file does here:
email {{EMAIL}}, phone {{PHONE}}.

## Anything else: HTML

Markdown can hold HTML for what it cannot do itself, such as a button:

```
<a class="btn primary" href="/contact/">Get in touch</a>
```

<a class="btn primary" href="/contact/">Get in touch</a>
