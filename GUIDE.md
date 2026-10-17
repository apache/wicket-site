# Writing the user guide

The user guide lives in `_guide/`, one Markdown file per page, and is published under `/docs/`. Every page has one job, one of the four kinds below, and belongs to one topic. Readers find pages through search, through the topic pages that gather a topic's pages of every kind, and through the class index. All three are built from the front matter, so the front matter is part of the content.

## Front matter

```yaml
---
title: Validate form input
type: howto
topic: forms
summary: Make fields required, check their values with validators and show the errors next to the form.
since: 10
apis: [IValidator, StringValidator, EmailAddressValidator, FeedbackPanel]
keywords: [required, error message, constraint]
order: 20
source: [forms2/forms2_2.adoc]
---
```

- **title**: what the page is about, in the reader's words, not the API's. How-to guides start with a verb ("Validate form input", "Upload files"); reference pages name the thing described ("Form components", "Wicket tags"); explanation pages name the subject ("Stateful and stateless pages"); tutorials name what the reader builds ("Build your first application").
- **type**: `tutorial`, `howto`, `reference` or `explanation`.
- **topic**: one of the ids in `_data/guide.yml`.
- **summary**: one sentence, at most about 25 words, saying what the reader gets from the page. It is shown in listings and search results.
- **since**: the oldest supported release line the page is correct for. See [Versions](#versions).
- **apis**: the Wicket classes, interfaces and annotations the page explains, by simple name. They feed the class index and search, so list the ones a reader would look up, not every class that appears in passing.
- **keywords**: words a reader may search for that are not in the title or summary, such as synonyms, terms from other frameworks, or the error message they are seeing.
- **order**: position within the topic and kind, lowest first. Tutorials are read in this order.
- **source**: the files of the AsciiDoc guide in `wicket-user-guide/src/main/asciidoc` this page was written from, so older guide links can be redirected.

## The four kinds

**Tutorial**: a lesson. The reader builds something that works, step by step, and has a working result at the end of each step. Numbered steps, one way of doing things, no alternatives, no background beyond a sentence. Link to the explanation pages at the end instead of explaining along the way.

**How-to guide**: directions for a competent user with a goal. Open with one sentence on when you need it, then the steps and the code. Leave out what the reader does not need for this goal; mention a variant in a sentence and link to it. Link the reference and explanation behind a step where the step needs it.

**Reference**: a description of the machinery: classes, tags, settings, lifecycle stages, the order of a lookup. Tables and lists with a consistent structure, complete within their scope, and short examples of use. No instructions and no reasoning.

**Explanation**: why Wicket works the way it does: the design, the trade-offs, the alternatives, how parts relate. No steps. Explanation is where "stateful", "detach" and "component tree" are made to make sense.

A page that does two of these jobs is two pages. When a section starts explaining in the middle of a how-to guide, move it to an explanation page and link to it.

## Versions

The guide describes the release lines in service: the current LTS and the current quarterly release (see `_data/releases.yml`). Lines out of service keep their single-page guide, linked from the Documentation page.

`since` holds the oldest line in service for which the page is correct. A page written for Wicket 10 that still holds on 11 has `since: 10`. When a page is updated in a way that no longer holds for an older line, raise `since` to the line it now requires. Do not keep a second copy for the old line. When the oldest line leaves service, pages with a lower `since` need no change.

When a single paragraph differs between the lines in service, keep one page and mark the paragraph:

```markdown
> Since Wicket 11, `AjaxFormComponentUpdatingBehavior` also processes the
> components inside a `FormComponentPanel`.
{: .since}
```

## Writing

- Address the reader as "you". Present tense, active voice, short sentences.
- Plain words before Wicket words: say what something does before naming the class that does it.
- Code compiles against the release line in `since`. Prefer what current Wicket favours: lambda models (`LambdaModel`, `IModel` lambdas), `onConfigure` over overriding `isVisible`, `Component#setOutputMarkupId`.
- Show the Java and the HTML side by side when both are needed: a fenced block per file, each preceded by the file name in italics, like *HomePage.java*.
- Headings in the page are `##` and `###`; the page title is the only `#` and comes from the front matter. Sections at `##` level appear in the "On this page" rail and as search results of their own, so give them headings a reader would search for.
- The layout lists the other pages of the topic under every page, so do not end a page with a list of related pages; link in the text where a link helps.
- Link to other guide pages with `{{ site.baseurl }}/docs/<slug>.html`, to a section with `#<heading-id>`.
- Images go in `img/guide/` and are referenced as `{{ site.baseurl }}/img/guide/<file>`.

## Releases

The AsciiDoc guide in apache/wicket (`wicket-user-guide/src/main/asciidoc`) remains where the documentation is written alongside the code. At every release, carry its changes over into these pages:

1. Fetch the Wicket repository and run `_previews/guide-changes.sh <previous release tag> <new release tag>`, for example `rel/wicket-11.0.0 rel/wicket-12.0.0`. It lists every changed guide file with the pages whose `source` names it, and the pages to review; `--diff` adds the changes themselves.
2. Rewrite each change into the page it belongs to, in the kind of that page. A new section that no page names in its `source` gets a page of its own in a topic, or joins the `source` of an existing page.
3. Check whether the change also reached the LTS line, by running the script for the LTS release tags as well. A change only on the new line gets a `{: .since}` note, or raises the page's `since` when the whole page no longer holds for the LTS. A change backported to the LTS is an ordinary edit.
4. When a release line leaves service, the pages need no change: a page whose `since` names that line is still correct for the lines after it.

Corrections made directly to these pages do not flow back to the AsciiDoc guide. Send them to apache/wicket as well, so the next release does not carry the old text over again.
