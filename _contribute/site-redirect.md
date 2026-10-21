---
title: Redirect an old URL
type: howto
topic: site
summary: Keep links in mails, announcements and other sites working when a page moves or disappears.
order: 60
---

Mailing list archives, release announcements and Stack Overflow answers link to the site for years. When you move, rename or remove a page, redirect its old URL to where the content is now.

Add a line to `.htaccess` at the root of the repository:

```apache
Redirect 301 /start/download.html /versions/
```

The first path is the old URL, the second where it goes. A fragment in the old link, like `#maven`, is kept, so give the section on the new page the same id.

For a whole family of URLs, use a pattern:

```apache
RedirectMatch 301 ^/start/wicket-([0-9.]+)\.x\.html$ /versions/wicket-$1.x/
```

Jekyll copies `.htaccess` into `content/`, and the Apache web server of the ASF applies it. Your local preview and design previews on GitHub Pages do not, so test a redirect after it is published:

```shell
curl -sI https://wicket.apache.org/start/download.html | grep -i location
```
