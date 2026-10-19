---
title: Add a page to the documentation
type: howto
topic: site
summary: Write a new page for the documentation under /docs/, give it the front matter that files it, and check it in search and on its topic page.
order: 40
---

Every page of the documentation is one Markdown file in `_guide/`, published as `/docs/<file name>.html`. A page does one job, in one of four kinds, for one topic. The topic pages, the pages per kind, the A–Z index and the search are all built from its front matter, so a page needs no links from elsewhere to be found.

## Decide what the page is

Pick the kind from what the reader wants:

| The reader wants to | Kind | Title starts with |
|---|---|---|
| learn by building something | `tutorial` | what they build: "Build a form that saves data" |
| reach a goal they already have | `howto` | a verb: "Upload files" |
| look up how something is defined | `reference` | the thing: "Wicket tags" |
| understand why Wicket works this way | `explanation` | the subject: "Stateful and stateless pages" |

When a page needs a second kind, it is two pages that link to each other.

## Create the file

Name the file after the page, in lowercase words joined by dashes, and start it with front matter:

```yaml
---
title: Upload files
type: howto
topic: forms
summary: Let users upload one or more files with a form, and limit their size and type.
since: 10
apis: [FileUploadField, FileUpload]
keywords: [multipart, upload size, MultipartFormData]
order: 60
---
```

- `topic` is one of the ids in `_data/guide.yml`.
- `summary` is one sentence of at most about 25 words; listings and search results show it.
- `since` is the oldest line in service the page is correct for. A page about a feature of the next release gets that release's series, and says it is upcoming until it ships.
- `apis` lists the classes the page explains, for the A–Z index and search.
- `keywords` are words a reader searches for that are not in the title or summary.
- `order` places the page within its topic and kind, lowest first.

## Write it

Address the reader as "you", in short sentences. Use `##` and `###` headings: `##` sections appear in the page's "On this page" rail and as search results of their own. Show Java and HTML side by side when both are needed, each code block preceded by its file name in italics. Link to other pages with `{{ "{{ site.baseurl " }}}}/docs/<file name>.html`.

When one paragraph differs between the lines in service, mark it instead of copying the page, with N the newer line:

```markdown
> Since Wicket N, what the newer line does differently, in one or two
> sentences.
{: .since}
```

`GUIDE.md` at the root of the repository holds the complete rules for the documentation.

## Check it

Run the site and open the page, its topic page under `/docs/topics/`, and its kind under `/docs/kinds/`. Search for one of its keywords on <http://localhost:4000/docs/>. The build warns about a page with an unknown topic or kind, a missing summary, and links to documentation pages that do not exist.
