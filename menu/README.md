# Menu extension

Your menu or price list at `/menu/`: sections such as Breakfast, Lunch and
Drinks, each dish with its price, a short description and tags such as V for
vegetarian. Made for restaurants, cafés and bars, and just as good for the
price list of a salon, a garage or a workshop.

## Install

1. Copy the `menu` folder into the `extensions` folder of your website.
2. Run `bash build.sh`.

The first build puts an example menu in `content/menu/` and adds "Menu" to
the menu in `site.conf`.

**Switch it off:** rename the folder to `_menu` and delete its line in `MENU`.

**A price list at /prices/:** rename the folder `extensions/menu` to
`extensions/prices` before the first build. The page, its content folder
(`content/prices/`) and its address follow the name; change the link text in
`MENU` to "Prices".

## A section

One text file per section. The number at the start sets the order:

```
content/menu/1_breakfast.txt
content/menu/2_lunch.txt
content/menu/3_drinks.txt
```

```
---
title: Breakfast
note: Until 11:30
---
Granola with yoghurt | 7.50 | V
Toasted oats and seeds, seasonal fruit, honey.

Eggs on sourdough | 9.50 | V
Two poached eggs, spinach and hollandaise.

Espresso | 2.40
```

Each dish is a paragraph, with an empty line between dishes:

- **First line:** the name, the price and the tags, separated by `|`. Write
  the price as you want it shown: `9.50`, `€9.50` or `9,50 €`. Several tags
  are separated by commas: `V, GF`. Price and tags are optional.
- **Lines below it:** the description, optional.

`note` is a line under the section's title. `draft: true` hides a section.

## The menu page

`content/menu/_index.html` holds its `title`, `eyebrow`, `description` and
text above the menu, and `legend`, which explains the tags at the end:
`legend: V vegetarian · VG vegan · GF gluten-free`. With more than one
section, buttons at the top jump to each section.

## Change the look

Copy a file from `extensions/menu/templates/` (`page.html`, `section.html`,
`dish.html`) to `templates/menu/` in your website and edit the copy.
