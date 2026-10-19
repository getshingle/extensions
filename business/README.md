# Business extension

Your opening hours on your pages, and your business details for Google and
other search engines.

- `{{OPENING_HOURS}}` shows a table of your hours on any page, for example
  the contact page. Days with the same hours share a line.
- `{{OPENING_HOURS_TEXT}}` is the same in one line, such as
  "Monday–Friday 9:00–17:30 · Saturday 10:00–14:00".
- `{{MAP_URL}}` is a link to your place on a map.
- Your home page gets structured data with your name, address, phone,
  opening hours and social links, which search engines use for maps and
  business listings.

## Install

1. Copy the `business` folder into the `extensions` folder of your website.
2. Run `bash build.sh`.

The first build puts `content/business/_index.html` in your website. It is
not a page: it holds your hours and details. Change them there.

**Switch it off:** rename the folder to `_business`.

## Your hours and details

```
---
type: LocalBusiness
monday: 9:00-17:30
tuesday: 9:00-17:30
wednesday: 9:00-17:30
thursday: 9:00-20:00
friday: 9:00-17:30
saturday: 10:00-14:00
sunday: closed
hours_note: Closed on public holidays.
street: 12 Harbour Lane
postal_code: RV1 4AB
city: Riverton
country: GB
map: https://maps.app.goo.gl/…
price_range: €€
---
```

| Field | |
| --- | --- |
| `monday` … `sunday` | `9:00-17:30`; two parts with a comma: `8:00-12:00, 13:00-17:00`; or `closed` |
| `hours_note` | A line under the table, such as holidays |
| `type` | What search engines should call your business (see below) |
| `street`, `postal_code`, `city`, `region`, `country` | Your address in parts; `country` is a code such as `GB`, `US`, `DE` or `SI` |
| `latitude`, `longitude` | Optional: your exact place, such as `46.0503` and `14.5046` |
| `map` | A link to your place: in Google Maps, find it and copy the link from "Share". Without it, `{{MAP_URL}}` searches for `ADDRESS` from `site.conf` |
| `price_range` | `€` to `€€€€`, or `$` to `$$$$` |

Your name, description, phone and social links come from `site.conf`. Your
email address is left out on purpose, to keep it from spam robots.

**Type:** one English word from [schema.org](https://schema.org/LocalBusiness),
for example `Restaurant`, `CafeOrCoffeeShop`, `BarOrPub`, `Bakery`, `Store`,
`Florist`, `HairSalon`, `BeautySalon`, `DaySpa`, `Dentist`, `Physician`,
`MedicalClinic`, `Optician`, `Attorney`, `AccountingService`,
`RealEstateAgent`, `ExerciseGym`, `SportsClub`, `Hotel`, `BedAndBreakfast`,
`Campground`, `ChildCare`, `Electrician`, `Plumber`, `HousePainter`,
`AutoRepair` or `TravelAgency`. When none fits, keep `LocalBusiness`.

## Show them

On the contact page, for example:

```
<h2>Opening hours</h2>
{{OPENING_HOURS}}
<p><a href="{{MAP_URL}}">Find us on the map</a></p>
```

At the bottom of every page: add it to `FOOTER_TEXT` in `site.conf`,
`FOOTER_TEXT="Open {{OPENING_HOURS_TEXT}}."`

**Other languages:** day names come from `DAYS` in `site.conf`, for example
`DAYS=(Ponedeljek Torek Sreda Četrtek Petek Sobota Nedelja)`. Hours are shown
as you write them, so `zaprto` works as well as `closed`.
