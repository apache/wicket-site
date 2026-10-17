---
title: Update the site for a release
type: howto
topic: site
summary: Announce a release on the site, update its version everywhere it appears, and start a new release line when a major release ships.
order: 20
---

Do this once the release is on Maven Central and the vote has passed. A patch or minor release takes two edits; the first release of a new major line takes a few more. The site reads every version number from `_config.yml` and every release line from `_data/releases.yml`, so the pages need no edits of their own.

## Patch and minor releases

1. In `_config.yml`, set the version of the line under `wicket:`, for example `version_10: 10.12.0`. When it is the newest line, also set `version`. Set `released` to the release date, and update the `-SNAPSHOT` versions in `versions` to the next development versions.
2. Write the announcement as a post in the year's folder: `2027/_posts/2027-01-08-wicket-10.12.0-released.md`. Keep the filename pattern `wicket-<version>-released`: the line's page under `/versions/` picks up its posts by it, and the blog shows a release as a row and a major release as a featured panel by it. [Write a blog post]({{ site.baseurl }}/contribute/site-blog-post.html) describes the front matter.
3. If the release was on the schedule, remove its entry from `_data/releases.yml`: the one with `status: scheduled` and the released `version`. The release lines page would otherwise still list it as upcoming.
4. [Build the site]({{ site.baseurl }}/contribute/site-first-change.html#4-build-the-site-for-publishing) and commit the changes together with `content/`.

Several lines released on the same day get one commit, with a post each.

## The first release of a new major line

On top of the steps above, for 12.0.0 for example:

1. In `_data/releases.yml`, change the entry of 12 from `status: boarding` to `status: current`, and give it what the lines in service have: `config: version_12`, `page: /versions/wicket-12.x/`, `role: "For new features"`, and `when: "Since Jan 2027"`. Remove its `version`.
2. Set the line it replaces to `status: superseded`, or to `status: eol` when it reaches end of life now. A line out of service keeps its `page`.
3. Give the next major release `status: boarding`. The documentation then marks pages for it as upcoming.
4. Add `version_12: 12.0.0` to `_config.yml`.
5. Create the line's page as `versions/wicket-12.x/index.md`. Copy the page of the previous line and change its front matter: `series`, `config`, `java`, `servlet` and `migration`, the link to the migration guide on the wiki. If the page already exists with `published: false`, set it to `true`.
6. Add the highlights of the release to `_data/highlights.yml` under the series, `"12":`. The line's page shows them as "New in Wicket 12".

The version plate in the menu, the release lines page, the panels on the release lines and documentation pages, and the quick start all follow from these changes.

## When a line leaves service

Set its `status` to `eol` and its `support` to how it ended, for example `"Ended with 14.0.0"`. After a release or two, remove the line from `_data/releases.yml` and add it to the table of unsupported releases on `versions/index.md`. Its page under `/versions/` stays.
