---
title: Make your first change to the site
type: tutorial
topic: site
summary: Clone the site, run it on your machine, change a page, and send the change as a pull request.
order: 10
---

In this tutorial you fix a sentence on the Community page and send the change to the Wicket project. You need Git, a GitHub account, and Docker or Podman. You do not need Ruby: the site runs in a container.

## 1. Fork and clone the site

The site's source is the `asf-site` branch of [apache/wicket-site](https://github.com/apache/wicket-site). Fork it on GitHub, then clone your fork:

```shell
git clone https://github.com/<your-account>/wicket-site.git
cd wicket-site
```

The clone checks out `asf-site`, the only branch you need.

## 2. Run the site

Start Jekyll in a Ruby container. It installs the site's gems the first time, which takes a minute:

```shell
docker run --rm -it -p 4000:4000 -v "$PWD":/site:z -w /site ruby:3.3 \
  bash -c "bundle install && bundle exec jekyll serve -H 0.0.0.0 -d /tmp/site"
```

With Podman, write `podman` instead of `docker`. When the output says `Server running`, open <http://localhost:4000>. The site you see is built from your clone.

`-d /tmp/site` keeps this preview inside the container. Without it, Jekyll writes to the `content/` folder, the copy of the site that goes live, with links to `localhost` in it.

## 3. Change a page

Open `community/index.md` in your editor. Below its front matter, the part between the two `---` lines, every page is Markdown. Change a sentence and save the file.

Jekyll notices the change and rebuilds. Reload <http://localhost:4000/community/> and you see your sentence. Stop Jekyll with Ctrl+C when you are done.

## 4. Build the site for publishing

The web server publishes the `content/` folder of the `asf-site` branch, so a change goes live with its rebuilt pages. Build them:

```shell
docker run --rm -v "$PWD":/site:z -w /site ruby:3.3 \
  bash -c "bundle install && bundle exec jekyll build"
```

`git status` now shows your change to `community/index.md` and the pages in `content/` it affected.

## 5. Send a pull request

Commit both, push, and open a pull request against `asf-site` on apache/wicket-site:

```shell
git checkout -b community-typo
git add community/index.md content
git commit -m "Community: fix a typo"
git push -u origin community-typo
```

A committer reviews it and merges it. Within a minute of the merge, your change is on wicket.apache.org.

Committers can push to `asf-site` directly, but a pull request lets someone else look first. [How the site is built and published]({{ site.baseurl }}/contribute/site-publishing.html) explains what happens after the merge.
