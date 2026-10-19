# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

The site serves two primary audiences with equal weight; neither wins by default when their needs conflict.

- **Java developers and architects evaluating Wicket** for a new or replacement web application. They need to understand quickly what Wicket is, how it differs from the alternatives they already know, and how to start.
- **Teams already running Wicket**, often in long-lived production applications. They come for release announcements, downloads and Maven coordinates, supported-version and end-of-life status, migration guides between major versions, the user guide, API docs and support channels.

Contributors (code, documentation, releases) are served by the Contribute and Community sections but were not named as a primary audience.

## Product Purpose

wicket.apache.org is the official home of Apache Wicket, an open source, component-oriented Java web framework open source since 2004 and maintained by the Apache Software Foundation since 2007. The site exists to win new users, keep existing users informed and upgrading, and route people to documentation, downloads and the community. Success means evaluators understand why Wicket fits their problem and reach the quick start, and existing users find the current release, its support status and the migration path without hunting.

The project is deliberately revitalizing itself. Development and contributions slowed over the past decade, partly because the core is stable, partly because the world moved to client-side JavaScript frameworks, and the slow release cadence made contributing less attractive in turn. Wicket 11.0.0 (first week of October 2026) starts a time-based release model to break that cycle. The site has to carry that renewal visibly, to existing users, evaluators and prospective contributors, without alienating the community and the long-lived applications that depend on Wicket's stability.

## Positioning

What a visitor should remember Wicket for, compared to Spring MVC/Thymeleaf, Vaadin, or a JavaScript front end behind a Java API:

1. **Complex, dynamic pages built from complex reusable components.** Wicket's component model is meant for rich, stateful UIs assembled from components that encapsulate markup, behavior and state.
2. **Plain Java + HTML.** Behavior lives in Java, markup stays plain HTML, and no JavaScript build chain is required.
3. **Security by default.** Full Content Security Policy support without `unsafe-inline`; Wicket adds nonces to header contributions automatically.

## Operating Context

- Visitors arrive from search, Maven Central, mailing-list and ASF release announcements, the Atom feed (`atom.xml`), and links in migration guides on the Apache Confluence wiki.
- **Release model from Wicket 11.0.0 on** (announced 2026-09-11, `2026/_posts/2026-09-11-release-cadence.md`, Release Policy on `start/download.md`): a new major release every three months; every fourth major is an LTS, supported until the next LTS. Schedule: 11.0.0 first week of October 2026, 12.0.0 January 2027, 13.0.0 April 2027, 14.0.0 (LTS) first week of July 2027, supported until 18. Wicket 10 is the first LTS, supported until 14 ships. At most two release lines are maintained at once: the current LTS and the current quarterly release. Support applies to release lines, not features; features carry forward from `main`.
- 8.x and 9.x each get one final release and are then end of life, ending support for `javax.servlet`.
- API stability remains a stated commitment: breaking changes only when needed, deprecated alternatives kept where possible, and every change documented in the migration guide.
- Every release produces a news post and updates version numbers in `_config.yml`. With quarterly majors this happens four times a year plus patch releases, so release-day site edits must stay small and mechanical.
- Existing users typically act on the site by copying a Maven dependency snippet, following a migration guide, or checking whether their version is still supported.
- External destinations the site routes to: the user guide and Javadoc, the Confluence wiki, live examples (`live_examples_url` in `_config.yml`), GitHub (issues and contributions, after the move away from JIRA per INFRA-28383), mailing lists and Slack.

## Capabilities and Constraints

- **Current stack:** Jekyll 3+ with Kramdown and Rouge, Sass in `_sass/`, layouts in `_layouts/`, shared fragments in `_includes/`. Built output goes to `content/` and is committed on the `asf-site` branch. Keeping Jekyll was not confirmed as a hard constraint; any change of build stack is an open decision, not a given.
- **Version data is centralized** in `_config.yml` (`wicket.version`, per-branch versions, release date, version list). Pages must keep reading versions from there instead of hard-coding them.
- **Volunteer-maintained.** Committers edit pages in Markdown. Design work must keep pages easy to author and update without bespoke, fragile markup; release-day edits must stay mechanical.
- **ASF website policy applies:** required links to the Apache license, security, sponsorship/thanks, events and privacy policy; Apache trademark attribution; no third-party trackers; no externally hosted fonts or scripts that leak visitor data.
- Site sections: Docs (`docs/`, the documentation from `_guide/`), Blog (the news archive), Community (`community/`: getting help, bugs, security, mailing lists) with Contribute (`contribute/` and `_contribute/`), Releases (`versions/`: the release lines, with a page per line; the version plate leads to the newest line in service), the quick start (`start/quickstart.md`), Learn (`learn/`), and the Apache page in the footer.

## Brand Commitments

- Name: **Apache Wicket**, always with the Apache prefix on first mention, per ASF trademark practice.
- **Every design carries the Apache Wicket mark: the orange circle with the white figure**, taken from the registered assets in `img/` (`logo-apachewicket.svg`, with its white and tungsten variants), never redrawn or replaced. The wordmark "Apache Wicket" beside it may be set in the design's own heading face, or the registered wordmark may be used as a whole.
- **Every design shows the ASF logo** and links it to apache.org, per ASF branding policy. Use the current logo (`img/asf_logo.svg`, from the ASF press kit at apache.org/foundation/press/kit/), self-hosted; on dark grounds place it on a light panel so its purple lettering stays legible. `img/asf_logo_url.svg` is the old feather logo.

## Evidence on Hand

- News archive with release announcements from 2009 to 2026 (year folders at the repository root, `news/`, `atom.xml`).
- Books about Wicket with covers in `learn/books/`; presentations in `learn/presentations/`; examples in `learn/examples/`.
- "Built with Wicket" showcase fed from builtwithwicket.tumblr.com (`_includes/builtwithwicket.html`, `_tumblr/`, `tumblr.json`).
- Live examples at the URL in `_config.yml`.
- No customer testimonials, adoption statistics, benchmarks or named reference customers are on hand. Future work must not invent them.

## Product Principles

1. **The homepage sells the framework.** It leads with what Wicket is and how it works, then why to choose it, proof that it lasts, and how to start. The release model is supporting information: on the homepage it is one compact element (the lines in service, the next departures, lines that have just gone out of service, a link), never a full timetable, and the full release lines, release policy and upgrade paths live on the download page. Nobody chooses a framework because it ships often.
2. **Serve the evaluator and the incumbent equally.** The homepage and top-level navigation must answer "why Wicket" and "what's current, how do I upgrade" without one burying the other; for the incumbent, "what's current" is answered in one glance and "how do I upgrade" one click away.
3. **Show the mechanism, not the slogan.** Claims about components, plain HTML and CSP should be backed by real code, real markup or real configuration a Java developer recognizes. The mechanism to show is the component model (a tree of Java components bound to plain HTML), not the release calendar.
4. **Release facts are always one step away.** Current versions, support and end-of-life status, and migration paths stay accurate and immediately findable: one link from every page, never a timetable on the homepage.
5. **Easy for volunteers to keep correct.** Anything that needs updating on release day must be data-driven or plain Markdown.
6. **Renew without displacing.** The revitalization must read as new energy to newcomers and as continuity to the people already here: LTS users, long-lived applications and long-time contributors keep their place, their paths and their trust.
7. **Behave like an Apache project.** Respect ASF policy, credit the community, and make no claims the project cannot back.
