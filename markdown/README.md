# Markdown extension

Write pages, blog posts and other entries in Markdown (`.md`) instead of HTML.
Markdown is plain text with a few signs: `## Heading`, `**bold**`,
`[a link](https://example.com)`, `- a list item`.

This extension needs one extra program on your computer, **cmark-gfm**.
Without the extension, Shingle only reads `.html` files and needs nothing.

## Install

1. Install cmark-gfm:
   - **macOS:** install [Homebrew](https://brew.sh), then run `brew install cmark-gfm`
   - **Debian, Ubuntu:** `sudo apt install cmark-gfm`
   - **Windows:** use WSL (Ubuntu inside Windows): install it from the
     Microsoft Store, then run `sudo apt install cmark-gfm` and build there
2. Copy the `markdown` folder into the `extensions` folder of your website.
3. Run `bash build.sh`.

If cmark-gfm is missing, the build stops and tells you how to install it.

## Write in Markdown

Any page or entry can be a `.md` file instead of `.html`, with the same
header at the top:

```
---
title: About us
description: One sentence for search results.
---
We are a small studio by the river.

![The studio from the street](studio.jpg "Our studio since 2015")
```

A picture alone on its line gets a caption from its title, in quotes.
Tables, ~~strikethrough~~ and plain web addresses work too.
