# Schedule extension

A weekly timetable at `/schedule/`: one column per day on a wide screen, one
day below the other on a phone. `{{SCHEDULE}}` shows it on any other page.
For classes, courses, opening times of rooms, or a day in a kindergarten.

## Install

1. Copy the `schedule` folder into the `extensions` folder of your website.
2. Run `bash build.sh`.

The first build puts an example week in `content/schedule/` and adds
"Schedule" to the menu in `site.conf`.

**Switch it off:** rename the folder to `_schedule` and delete its line in `MENU`.

## A day

One text file per day. The number at the start sets the order:

```
content/schedule/1_monday.txt
content/schedule/2_tuesday.txt
```

```
---
title: Monday
---
07:00-08:00 | Morning flow | Maja
18:00-19:15 | Vinyasa | Maja | Studio 1
Closed in the afternoon
```

One line per class: the time, the name and any details (teacher, room,
level), separated by `|`. A line without `|` is a note, such as "Closed". The
columns do not have to be days: rooms, groups or months work the same way.

## The schedule page

`content/schedule/_index.html` holds its `title`, `eyebrow` and
`description`, and text that appears below the timetable.

## Change the look

Copy a file from `extensions/schedule/templates/` (`page.html`, `day.html`,
`class.html`) to `templates/schedule/` in your website and edit the copy.
