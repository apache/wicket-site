---
title: Carry the reference guide's changes into the documentation
type: howto
topic: site
summary: At a release, find what changed in the AsciiDoc reference guide in apache/wicket and rewrite those changes into the pages under /docs/.
order: 50
---

The reference guide in apache/wicket, `wicket-user-guide/src/main/asciidoc`, is still where documentation is written alongside the code, and it is the single document every release ships. The pages under `/docs/` were written from it, and each names its sources in the `source` front matter. Do this at every release, after [updating the site]({{ site.baseurl }}/contribute/site-release.html).

## List the changes

Clone apache/wicket next to the site's repository, as a folder named `wicket`, and fetch its tags. Then run the script with the tags of the previous and the new release:

```shell
_previews/guide-changes.sh rel/wicket-10.10.0 rel/wicket-10.11.0
```

It lists every changed file of the reference guide, the pages whose `source` names it, and the pages to review. Add `--diff` to see the changes themselves. Set `WICKET_DIR` when your clone of apache/wicket is elsewhere.

## Rewrite each change

Rewrite a change into the page it belongs to, in that page's kind: a new step in a how-to guide, a new row in a reference table. A new section that no page names in its `source` gets a page of its own, as in [Add a page to the documentation]({{ site.baseurl }}/contribute/site-docs-page.html), or joins the `source` of an existing page.

## Mark what only the new line has

Run the script for the release tags of the LTS line as well. A change that reached only the new line gets a `{: .since}` note on its paragraph, or raises the page's `since` when the whole page no longer holds for the LTS. A change that was backported to the LTS is an ordinary edit.

When a line leaves service, the pages need no change: a page whose `since` names that line is still correct for the lines after it.

## Send corrections back

Corrections made directly to the pages under `/docs/` do not flow back into the reference guide. Send them to apache/wicket as well, so the next release does not carry the old text over again.
