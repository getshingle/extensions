# Gallery extension

Photo albums, each with its own page, and photos on the gallery page itself.
A photo grows out of its small picture to fill the screen; the arrow keys go to the next one.
On a device set to reduce motion, it opens at once, without moving.

## Install

1. Copy the `gallery` folder into the `extensions` folder of your website,
   and `collection.sh` and `collection.css` straight into `extensions` too
   (the download has all three; replacing older copies is fine).
2. Run `bash build.sh`.

The first build puts examples in `content/gallery/` and adds "Gallery" to the
menu in `site.conf`.

**Switch it off:** rename the folder to `_gallery` and delete its line in `MENU`.

## Photos

```
content/gallery/garden.jpg                           on the gallery page
content/gallery/01_summer-wedding/index.html         an album → /gallery/summer-wedding/
content/gallery/01_summer-wedding/01_ceremony.jpg    its photos, in the order of their names
content/gallery/01_summer-wedding/01_ceremony.txt    optional: a caption for 01_ceremony.jpg
```

- **Names:** a photo's name becomes its description for people who cannot
  see it: `01_ceremony-under-the-oak.jpg` → "Ceremony under the oak". A
  caption file replaces it, so give your photos words, not camera numbers.
- **Cover:** `cover.jpg` in an album, or else its first photo.
- **Size:** 2000 pixels on the long side is plenty; save photos as JPG.
  Large files from a camera make the page slow, so make them smaller first.

The album's header:

```
---
title: Summer wedding
summary: One sentence for the album's card.
---
<p>Optional text above the photos.</p>
```

The number at the start of the album's folder sets the order of the albums.

## The gallery page

`content/gallery/_index.html` holds its `title`, `eyebrow`, `description` and
text above the albums. Photos straight in `content/gallery/` appear below the
albums.

## Change the look

Copy a file from `extensions/gallery/templates/` (`list.html`, `card.html`,
`item.html`) to `templates/gallery/` in your website and edit the copy.
