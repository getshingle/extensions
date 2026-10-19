# Embed extension

Videos, maps and booking calendars from other websites, such as YouTube,
Vimeo, Google Maps, OpenStreetMap and Calendly, on your pages. They load only
when a visitor presses the button. Until then nothing comes from those
websites, and they set no cookies: better for privacy, and your pages stay
fast.

## Install

1. Copy the `embed` folder into the `extensions` folder of your website.
2. Run `bash build.sh`. The first build puts two examples in
   `content/embed/`: a map and a video.
3. Put an embed into a page with its name in capitals, for example in
   `content/contact.html`:

   ```
   <section class="narrow">
     {{EMBED_MAP}}
   </section>
   ```

**Switch it off:** rename the folder to `_embed` and remove the `{{EMBED_…}}`
values from your pages.

## An embed

One text file each. Its name gives its value: `map.txt` is `{{EMBED_MAP}}`,
`studio-tour.txt` is `{{EMBED_STUDIO_TOUR}}`.

```
---
title: A walk through the studio
link: https://www.youtube.com/watch?v=…
---
An optional caption under it.
```

`link` can be:

- **A video:** its YouTube or Vimeo address. YouTube videos load from
  youtube-nocookie.com.
- **A map:** in Google Maps, "Share" → "Embed a map" → copy the code; in
  OpenStreetMap, "Share" → "HTML" → copy the code. Paste the whole code after
  `link:`, on one line.
- **A booking calendar:** your Calendly link, such as
  `https://calendly.com/your-name/30min`. Other services work too when they
  allow their page to be embedded; use the embed code they give you.

| Field | |
| --- | --- |
| `title` | Shown on the placeholder and read out by screen readers |
| `height` | A height in pixels, such as `700`, instead of the usual shape |
| `button`, `open`, `note` | Your own texts for the button, the link and the line below them, for example in another language |

Without JavaScript, or when a visitor would rather not load it here, the
second button opens the video, map or calendar on its own website.

**On your computer:** some videos only play once the website is online.
