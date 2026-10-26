---
title: How the site is built and published
type: explanation
topic: site
summary: Why the built site is committed next to its source, how a commit reaches wicket.apache.org, and why release day only changes data.
order: 80
---

## One branch with source and result

The site is a [Jekyll](https://jekyllrb.com/) site in the `asf-site` branch of apache/wicket-site. The branch holds two things: the source, Markdown pages with their layouts and data, and in `content/` the HTML that Jekyll builds from it. Whoever changes the source builds the site and commits both.

The ASF's web servers publish `content/` as wicket.apache.org. The `.asf.yaml` file at the root of the branch asks for this with `publish: whoami: asf-site`, and the ASF's publishing service picks up every commit to the branch within a minute. No build server is involved: what is committed in `content/` is what visitors get.

That is why the site is built on your machine and not by the ASF. Many ASF sites use a build service that only knows Pelican, or a GitHub Actions workflow that builds and pushes the result. Wicket's site uses its own Jekyll plugins, for the documentation's indexes and the news archives, so it is built locally with the gems in the `Gemfile`.

## Build and serve are not the same

`jekyll build` builds the site for wicket.apache.org: the `url` in `_config.yml` is `https://wicket.apache.org`, and feeds and links that need a full address use it. `jekyll serve` builds the site for your machine and replaces that address with `localhost`. Anything you commit to `content/` has to come from `jekyll build`, or the Atom feed would send readers to `localhost`. For local previews, `jekyll serve -d /tmp/site` keeps that copy out of `content/`.

## Data instead of pages

With a major release every quarter and patch releases in between, the site changes often, and the people who change it are volunteers releasing Wicket, not web developers. So a release is data: the version numbers in `_config.yml`, the release lines in `_data/releases.yml`, the highlights in `_data/highlights.yml`, and a post. The version plate in the menu, the release lines page, the line pages, the panels on the documentation and the quick start are generated from that data. A release updates all of them without anyone editing a page, and none of them can fall behind another.

The documentation follows the same idea with versions. A page states the oldest line it is correct for in `since`, and paragraphs that differ between lines carry a note. One page serves every supported line, a reader filters by the version they use, and a line reaching end of life needs no edit at all.

## Redirects keep old links working

Release announcements, mailing list archives and answers elsewhere link to the site for years. The web server applies `.htaccess`, which Jekyll copies into `content/`, so a moved page keeps its old address as a redirect. See [Redirect an old URL]({{ site.baseurl }}/contribute/site-redirect.html).
