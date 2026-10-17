---
title: Write a blog post
type: howto
topic: site
summary: Publish a release announcement, a security advisory or an article on the blog, and decide whether it is featured.
order: 30
---

Every post appears on the blog and in the Atom feed, and the newest two on the homepage. Posts about a release also appear on the page of its release line.

## Create the post

Write the post in Markdown in the `_posts` folder of the year it is published, with the date and a short name in the filename:

```text
2026/_posts/2026-11-03-csp-in-practice.md
```

Start it with front matter:

```yaml
---
layout: post
title: Content Security Policy in practice
description: How Wicket adds nonces to every header contribution, and what that means for your own scripts.
---
```

The first paragraph is the summary on the blog. To end the summary earlier, put `<!--more-->` where it should stop. `description` replaces the summary with a sentence of your own; a release announcement that opens with "The Apache Wicket PMC is proud to announce" reads better with one.

## Name it so the site recognizes it

The blog features articles, major releases and security advisories as panels, and lists other releases as dated rows. It tells them apart by the filename:

| Filename contains | Kind | Shown as |
|---|---|---|
| `cve-` | Security advisory | Featured panel |
| `wicket-<x>.0.0-released`, or `wicket-<x>-released` | Major release | Featured panel |
| `wicket-<version>-released` | Release | Row |
| anything else | Article | Featured panel |

The page of a release line, such as `/versions/wicket-10.x/`, shows the posts whose filename contains `wicket-10.` and the major release `wicket-10-released`. For a post about more than one line, list them in its front matter:

```yaml
lines: ["10", "11"]
```

## Feature it or not

`featured: true` puts any post among the panels; `featured: false` turns a panel into a row. The blog front page shows panels only for posts of the last three years, so old advisories do not crowd out new articles.

## Check and publish

Run the site and open <http://localhost:4000/news/> to see the post in place, then build and commit it as in [Make your first change to the site]({{ site.baseurl }}/contribute/site-first-change.html). The release announcement is also sent to the announce, users and dev mailing lists; the post is the copy on the site.
