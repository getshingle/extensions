# Downloads extension

Files to download, such as PDFs, forms, price lists and brochures, listed with
their type and size at `/downloads/`. `{{DOWNLOADS}}` shows the list on any
other page.

## Install

1. Copy the `downloads` folder into the `extensions` folder of your website.
2. Run `bash build.sh`.

The first build puts example PDFs in `content/downloads/` and adds
"Downloads" to the links at the bottom of every page (`LEGAL` in
`site.conf`). Move the line to `MENU` to have it in the menu instead.

**Switch it off:** rename the folder to `_downloads` and delete its line in `LEGAL`.

## Files

Put the files in `content/downloads/`:

```
content/downloads/1_price-list-2026.pdf      → "Price list 2026", PDF, 120 KB
content/downloads/1_price-list-2026.txt      optional: a title and a description
content/downloads/2_forms/registration.pdf   a folder makes a group: "Forms"
```

- **Title:** from the file's name: `price-list-2026.pdf` becomes "Price
  list 2026". A number at the start, such as `1_`, sets the order and is not
  shown, neither in the title nor in the file's address.
- **Description:** a text file with the same name. Its first line replaces
  the title, the lines below it are a short description:

  ```
  Price list 2026
  All our treatments with their prices, valid from 1 January.
  ```
- **Groups:** files in a folder are listed under its name as a heading.

Name files with words and `-` instead of spaces. Keep files small: PDFs from
scans can be large, and visitors on phones download them.

## The downloads page

`content/downloads/_index.html` holds its `title`, `eyebrow`, `description`
and text above the files.

## Change the look

Copy `page.html` or `file.html` from `extensions/downloads/templates/` to
`templates/downloads/` in your website and edit the copy.
