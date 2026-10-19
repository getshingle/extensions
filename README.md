<p align="center"><a href="https://getshingle.github.io/extras/extensions/"><img src="https://getshingle.github.io/img/github/extensions.png" alt="Shingle extensions: blog, projects, news, team and more" width="720"></a></p>

# Shingle extensions

Add-ons for [Shingle](https://github.com/getshingle/shingle). Each one adds one
thing to your website and comes with example content to replace.

| Extension | What it adds | |
| --- | --- | --- |
| [blog](blog/) | Articles with pictures, newest first, and a feed | [demo](https://getshingle.github.io/demo/extensions/blog/) |
| [portfolio](portfolio/) | Projects with a page each, or a list of references | [demo](https://getshingle.github.io/demo/extensions/portfolio/) |
| [news](news/) | Short announcements as a dated list, and a feed | [demo](https://getshingle.github.io/demo/extensions/news/) |
| [team](team/) | A card and a page for each person | [demo](https://getshingle.github.io/demo/extensions/team/) |
| [careers](careers/) | Job openings with a page each, open or filled | [demo](https://getshingle.github.io/demo/extensions/careers/) |
| [privacy](privacy/) | A sample privacy policy, linked in the footer | [demo](https://getshingle.github.io/demo/extensions/privacy/) |
| [sitemap](sitemap/) | `sitemap.xml` and `robots.txt` for search engines | |
| [cloudflare](cloudflare/) | `_headers` and `_redirects` for Cloudflare Pages | |
| [markdown](markdown/) | Pages and posts in Markdown (needs cmark-gfm) | |

## Add one

1. Download it from the [guide](https://getshingle.github.io/extras/extensions/)
   and unzip it.
2. Move everything inside into the `extensions` folder of your website.
3. Run `bash build.sh`. The first time, it adds example content and a menu link.

Each extension's README explains its fields. `collection.sh` and
`collection.css` are shared by blog, portfolio, news, team and careers; they
come with each of those downloads.

## License

The `.sh` files are under the GNU AGPL 3.0 or later (`LICENSE`). Templates,
styles and example content end up in your website and are under the MIT
license (`LICENSE-MIT`).
