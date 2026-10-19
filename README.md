<p align="center"><a href="https://getshingle.github.io/extras/extensions/"><img src="https://getshingle.github.io/img/github/extensions.png" alt="Shingle extensions: services, menu, gallery, blog, team and more" width="720"></a></p>

# Shingle extensions

Add-ons for [Shingle](https://github.com/getshingle/shingle). Each one adds one
thing to your website and comes with example content to replace.

| Extension | What it adds | |
| --- | --- | --- |
| [services](services/) | What you offer: cards and a page per service, with prices and a book button | [demo](https://getshingle.github.io/demo/extensions/services/) |
| [pricing](pricing/) | Plans side by side, with a monthly/yearly switch | [demo](https://getshingle.github.io/demo/stillwater/pricing/) |
| [menu](menu/) | A menu or price list with sections, prices and tags | [demo](https://getshingle.github.io/demo/ember/menu/) |
| [schedule](schedule/) | A weekly timetable of classes or courses | [demo](https://getshingle.github.io/demo/stillwater/schedule/) |
| [portfolio](portfolio/) | Projects with a page each, or a list of references | [demo](https://getshingle.github.io/demo/extensions/portfolio/) |
| [gallery](gallery/) | Photo albums; photos open large with a click | [demo](https://getshingle.github.io/demo/extensions/gallery/) |
| [blog](blog/) | Articles with pictures, newest first, and a feed | [demo](https://getshingle.github.io/demo/extensions/blog/) |
| [news](news/) | Short announcements as a dated list, and a feed | [demo](https://getshingle.github.io/demo/extensions/news/) |
| [team](team/) | A card and a page for each person | [demo](https://getshingle.github.io/demo/extensions/team/) |
| [testimonials](testimonials/) | Quotes from clients, with stars | [demo](https://getshingle.github.io/demo/extensions/testimonials/) |
| [faq](faq/) | Questions and answers by topic | [demo](https://getshingle.github.io/demo/extensions/faq/) |
| [downloads](downloads/) | Files to download, with type and size | [demo](https://getshingle.github.io/demo/extensions/downloads/) |
| [careers](careers/) | Job openings with a page each, open or filled | [demo](https://getshingle.github.io/demo/extensions/careers/) |
| [business](business/) | Opening hours, and your business details for search engines | [demo](https://getshingle.github.io/demo/extensions/contact/) |
| [forms](forms/) | Contact and booking forms, through a form service | [demo](https://getshingle.github.io/demo/ember/contact/) |
| [embed](embed/) | Videos, maps and booking calendars, loaded after a click | [demo](https://getshingle.github.io/demo/extensions/contact/) |
| [privacy](privacy/) | A sample privacy policy, linked in the footer | [demo](https://getshingle.github.io/demo/extensions/privacy/) |
| [sitemap](sitemap/) | `sitemap.xml` and `robots.txt` for search engines |  |
| [cloudflare](cloudflare/) | `_headers` and `_redirects` for Cloudflare Pages |  |
| [markdown](markdown/) | Pages and posts in Markdown (needs cmark-gfm) | [demo](https://getshingle.github.io/demo/extensions/markdown/) |

## Add one

1. Download it from the [guide](https://getshingle.github.io/extras/extensions/)
   and unzip it.
2. Move everything inside into the `extensions` folder of your website.
3. Run `bash build.sh`. The first time, it adds example content and a menu link.

Each extension's README explains its fields, and the guide has a page for
each, with examples. `collection.sh` and `collection.css` are shared by blog,
news, team, careers, portfolio, services, testimonials, gallery and pricing;
they come with each of those downloads.

Many extensions also give you a value for any page, such as `{{TESTIMONIALS}}`,
`{{OPENING_HOURS}}` or `{{FORM_CONTACT}}`; their READMEs say which.

## License

The `.sh` files are under the GNU AGPL 3.0 or later (`LICENSE`). Templates,
styles and example content end up in your website and are under the MIT
license (`LICENSE-MIT`).
