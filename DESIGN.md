---
name: Apache Wicket
description: The project site for Apache Wicket, where one orange ribbon runs through the component tree under a seasonal photograph.
colors:
  ribbon: "#EE7F2D"
  ribbon-under: "#C9661F"
  ribbon-text: "#F39A55"
  ribbon-deep: "#9A430A"
  cloth: "#103C35"
  cloth-deep: "#0B2E28"
  muted: "#A8C7BD"
  paper: "#F6F8F7"
  paper-tint: "#E9F0ED"
  code-bg: "#E4ECE8"
  rule: "#CFDAD5"
  field-stroke: "#73877F"
  ink: "#14241F"
  ink-soft: "#4A5E57"
  code-green: "#1C5E43"
  code-tag: "#0F4A40"
typography:
  display:
    fontFamily: "Alegreya, Georgia, serif"
    fontSize: "clamp(3.4rem, 5.6vw, 5.1rem)"
    fontWeight: 700
    lineHeight: 0.9
    letterSpacing: "-0.022em"
  headline:
    fontFamily: "Alegreya, Georgia, serif"
    fontSize: "clamp(2.4rem, 4.4vw, 3.8rem)"
    fontWeight: 700
    lineHeight: 1.02
    letterSpacing: "-0.02em"
  section:
    fontFamily: "Alegreya, Georgia, serif"
    fontSize: "clamp(2rem, 3vw, 2.6rem)"
    fontWeight: 700
    lineHeight: 1.05
    letterSpacing: "-0.015em"
  title:
    fontFamily: "Alegreya, Georgia, serif"
    fontSize: "clamp(1.75rem, 2.6vw, 2.25rem)"
    fontWeight: 700
    lineHeight: 1.1
    letterSpacing: "-0.015em"
  subtitle:
    fontFamily: "Alegreya, Georgia, serif"
    fontSize: "1.45rem"
    fontWeight: 700
    lineHeight: 1.2
  lead:
    fontFamily: "Alegreya, Georgia, serif"
    fontSize: "clamp(1.25rem, 1.7vw, 1.5rem)"
    fontWeight: 400
    lineHeight: 1.3
  body:
    fontFamily: "Alegreya, Georgia, serif"
    fontSize: "1.1875rem"
    fontWeight: 400
    lineHeight: 1.55
  label:
    fontFamily: "Alegreya SC, Alegreya, Georgia, serif"
    fontSize: "1rem"
    fontWeight: 500
    lineHeight: 1.2
    letterSpacing: "0.03em"
  ui:
    fontFamily: "Alegreya Sans, Alegreya, sans-serif"
    fontSize: "1.0625rem"
    fontWeight: 500
    lineHeight: 1.2
  code:
    fontFamily: "JetBrains Mono, ui-monospace, SFMono-Regular, Menlo, monospace"
    fontSize: "0.8125rem"
    fontWeight: 400
    lineHeight: 1.65
rounded:
  square: "2px"
  bead: "3px"
spacing:
  pad-wide: "56px"
  pad-mid: "36px"
  pad-narrow: "18px"
  column-gap: "48px"
  section-y: "56px"
  measure: "68ch"
  mast-h: "76px"
  max: "1440px"
  ribbon-w: "7px"
components:
  button-primary:
    backgroundColor: "{colors.ribbon}"
    textColor: "{colors.ink}"
    typography: "{typography.ui}"
    rounded: "{rounded.square}"
    padding: "13px 18px"
  button-primary-hover:
    backgroundColor: "{colors.ribbon-text}"
    textColor: "{colors.ink}"
  bead:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink}"
    typography: "{typography.code}"
    rounded: "{rounded.bead}"
    padding: "0 1ch"
  bead-lit:
    backgroundColor: "{colors.ribbon}"
    textColor: "{colors.ink}"
    rounded: "{rounded.bead}"
  field:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink}"
    rounded: "{rounded.square}"
    padding: "0 44px 0 12px"
    height: "44px"
  code-block:
    backgroundColor: "{colors.code-bg}"
    textColor: "{colors.ink}"
    typography: "{typography.code}"
    rounded: "{rounded.square}"
    padding: "14px 16px"
  sheet:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink}"
    padding: "16px 18px 18px"
  cloth-band:
    backgroundColor: "{colors.cloth}"
    textColor: "{colors.paper}"
    padding: "40px 56px"
  footer:
    backgroundColor: "{colors.cloth}"
    textColor: "{colors.muted}"
    padding: "40px 56px 48px"
---

# Design System: Apache Wicket

## Overview

**Creative North Star: "The Ribbon Through the Tree"**

A Wicket page is a tree of Java components that mirrors its HTML, and the site is drawn the same way: one orange ribbon runs from the seasonal photograph at the top of a page down into the component tree, into the reading rail, into lists of documentation pages, folding at a square elbow into every child. The ribbon is the only loud element. Everything else is cool paper, bookcloth green and ink, set in a humanist book face.

Every page opens on a photograph of the current season (or a dated occasion) under a cool paper veil that only thickens where text sits. The homepage hero carries the lockup on it; every other page carries its title band on it, and the masthead lies on the same photograph. Below the photograph the page turns to paper for reading, with bookcloth green fields for the homepage component tree and the footer, and a pale green tint for alternating homepage sections and asides. The density is that of a well-set book: generous measure, ink rules above lists and tables, hairlines between rows, few boxes.

The world refuses the framework-homepage default of a headline, a code panel and three feature cards, and it refuses cream or warm paper.

**Key Characteristics:**
- One orange ribbon, drawn as a continuous band with square folded elbows, connecting parent to child wherever there is a hierarchy.
- A seasonal photograph behind the masthead and title of every page, under a paper veil.
- Bookcloth green fields for the tree and the footer; cool paper and a pale green tint for reading.
- Alegreya for headings and body, Alegreya SC for dates and small labels, Alegreya Sans for interface text, JetBrains Mono for code.
- Square corners (2px), beads at 3px, ink rules (2px) over lists and tables, hairlines (1px) between rows.

## Colors

A cool, green-grey book palette with a single warm voice: Wicket orange.

### Primary
- **Wicket Ribbon Orange** (`ribbon`): the ribbon itself, rules that open a highlighted list, the run of ribbon under the active menu item and before a supported line's status, the edge of LTS and Current tags, the lit bead, the one action button, text selection. Graphic use only; never text on paper.
- **Ribbon Reverse** (`ribbon-under`): the ribbon's back side on diagonal runs in the drawn tree, the stroke of knots, and the 1px edge of interactive beads on paper (the version plate, A–Z letters, slider controls), where it reaches 3.6:1.
- **Ribbon on Cloth** (`ribbon-text`): orange for text and code on the green fields (5.6:1), the focus ring on cloth, and the hover state of orange buttons.
- **Burnt Ribbon** (`ribbon-deep`): orange for text on paper (6.2:1): link underlines, dates, small-caps labels, list markers, Java keywords, the focus ring on paper.

### Secondary
- **Bookcloth Green** (`cloth`): the homepage component-tree band and the footer.
- **Deep Bookcloth** (`cloth-deep`): name chips in the narrow-screen tree list, the photo credit and season selector chips.
- **Lichen** (`muted`): secondary text on cloth (6.7:1).

### Neutral
- **Cool Paper** (`paper`): the page ground, sheets, fields, beads at rest. Also the veil over the photograph.
- **Pale Green Tint** (`paper-tint`): the second field for alternating homepage sections (Built with Wicket, Built by the people who use it), asides (end-of-life notes, version notes, blockquotes) and the phone release panel.
- **Code Ground** (`code-bg`): code blocks, inline code, the copy bar above documentation code.
- **Hairline** (`rule`): 1px row separators.
- **Field Stroke** (`field-stroke`, `--field`): input and select borders, the edge of End of life tags, the scrollbar thumb. 3.6:1 on paper and 3.3:1 on the tint, so form fields meet the 3:1 rule for component boundaries.
- **Ink** (`ink`): text, headings, the 2px ink rules, and text on orange.
- **Soft Ink** (`ink-soft`): secondary text, summaries, file names, table headers (6.5:1 on paper, 6:1 on the tint).
- **Code Green** (`code-green`) and **Tag Green** (`code-tag`): strings and numbers, and HTML tags and types, in highlighted code.

### Named Rules
**The One Ribbon Rule.** Wicket orange is a ribbon, a rule, a bead or the one action on a screen. It is never a fill for a panel, a heading color or a decorative wash beyond the light hover tint (`rgba(238, 127, 45, .16)`).

**The Two Oranges Rule.** Text in orange uses `ribbon-deep` on paper and `ribbon-text` on cloth. The bright `ribbon` carries ink text when it is a fill.

**The Cool Paper Rule.** The ground is cool paper with a green cast. No cream, no warm white, no pure white.

### Dark Mode
The site follows the visitor's system setting (`prefers-color-scheme: dark`); there is no switch. At night the paper turns to a green-black (`#0E1C19`), a shade under the bookcloth, so the component tree and the footer still read as fields of cloth. The tint becomes `#132622`, code ground `#182E29`, hairlines `#2A403A`, field strokes `#6A8279`. Ink turns light (`#E2EBE7`, 14:1) and soft ink `#A4B8B0` (8.4:1). Orange text on the ground takes the orange for cloth (`#F39A55`, 8:1); the ribbon, its reverse and the knots keep their colours. Sheets (the tree's files, the documentation search, the quick start) become `#16302A`, lighter than the ground so they still rise, and the code greens turn pale (`#9FD3AE` strings, `#86CBBE` tags, `#B9C9C2` operators). The veil over the photograph is the night ground, so the photograph darkens where text sits. Text on cloth (`--on-cloth`) and on an orange fill (`--on-ribbon`) keeps its colour in both modes, as does the light tile under the ASF logo. Built with Wicket screenshots are dimmed to 86% brightness.

## Typography

**Display Font:** Alegreya (with Georgia, serif)
**Body Font:** Alegreya (with Georgia, serif)
**Label Font:** Alegreya SC for dates and small labels; Alegreya Sans for interface text
**Mono Font:** JetBrains Mono (with ui-monospace), ligatures off

**Character:** One humanist book family in three cuts: the serif reads and titles, the small caps date and label, the sans runs the menu, buttons, metadata and table cells. All four families are self-hosted under the SIL Open Font License.

### Hierarchy
- **Display** (700, `clamp(3.4rem, 5.6vw, 5.1rem)`, 0.9): the homepage lockup "Apache Wicket" beside the mark. The lockup carries no version: the release panel below it names the lines.
- **Headline** (700, `clamp(2.4rem, 4.4vw, 3.8rem)`, 1.02): the title of every page on the photo band, at most 20ch wide.
- **Section** (700, `clamp(2rem, 3vw, 2.6rem)`, 1.05): homepage sections, the docs front page sections, the sections of a release line page.
- **Title** (700, `clamp(1.75rem, 2.6vw, 2.25rem)`, 1.1): h2 inside reading pages, documentation groups and the foot of a documentation page.
- **Subtitle** (700, 1.45rem, 1.2): h3 in reading pages, the Why Wicket items and the highlights; list entries in the serif run 1.2 to 1.35rem.
- **Lead** (italic 400 for the tagline and page subtitles; roman 400 for the definition and section leads): the sentence under a title.
- **Body** (400, 1.1875rem, 1.55; 1.6 in reading pages; 1.125rem on phones): running text, at a measure of 68ch.
- **Label** (Alegreya SC 500, about 1.05rem, letter-spacing .03 to .04em): dates, breadcrumbs, table and fact headers, rail and list headings, the LTS and Current tags. Small caps, never forced uppercase.
- **UI** (Alegreya Sans 400 to 700, about 1.0625rem): menu, version plate, buttons, link rows, summaries, metadata, table cells.
- **Code** (JetBrains Mono 400, .8125rem, 1.65; 11 to 12px in the component tree): code blocks, beads, file paths. Ligatures are off, so `<!--` and `<>` show as typed.

### Named Rules
**The Small Caps Rule.** Dates and labels are set in Alegreya SC in `ribbon-deep` or `ink-soft`. A label names the list, table or value directly below it; it is not a tag line above a heading.

**The Lining Numbers Rule.** Version numbers in the serif use lining figures; dates in lists use tabular figures.

## Layout

Content sits in a 1440px frame with side padding of 56px, 36px below 1400px, and 18px below 861px. The masthead is 76px tall on wide screens; below 1000px it is two rows (104px): the mark, wordmark and version plate, then the sections with the ASF feather and GitHub. Homepage sections and two-column heads use a 4 : 8 grid with a 48px gap: the title on the left, the text or list on the right. Sections run 56px top and 60px bottom on wide screens, 44 and 48px on phones.

The homepage runs: the hero on the photograph; From the blog on paper; the component tree on cloth; Why Wicket on paper; Built with Wicket on the tint; the five lessons on paper; Built by the people who use it on the tint; the cloth footer.

Reading pages have a title band on the photograph (at least 220px tall, title bottom-aligned), then a reading column of up to 54rem with a 68ch measure. From 1100px the column gets a sticky 15rem rail on the left for the page's sections; the ribbon of the rail drops from the photograph's edge. Below 1100px the rail is a first-level index above the text. Documentation pages put the search sheet beside the title from 1000px. A release line page has its name and role on the band, then its facts on paper under a 2px ink rule.

On phones the photograph becomes its own band (380px on the homepage, 260px on other pages) that fades to paper; the title and lockup read on paper below it, followed by the photo credit (and in review builds the season selector). No page scrolls sideways at 390px; wide tables and code scroll inside their own box.

## Elevation & Depth

Flat by default. Depth comes from three things: the photograph under its veil, the change of field from paper to tint to cloth, and a single family of soft, low sheets that lift paper off a darker ground.

### Shadow Vocabulary
- **Sheet on cloth** (`box-shadow: 0 1px 0 rgba(0, 0, 0, .06), 0 16px 36px -22px rgba(0, 0, 0, .55)`): the Java and markup sheets in the component tree.
- **Sheet on paper** (`box-shadow: 0 1px 0 rgba(20, 36, 31, .06), 0 14px 30px -20px rgba(6, 26, 22, .35)`): the quick start sheet; the documentation search sheet and the Built with Wicket screenshots use the same shape at .45.
- **Dropdown** (`box-shadow: 0 1px 0 rgba(20, 36, 31, .06), 0 24px 48px -24px rgba(6, 26, 22, .55)`): search results over the page.
- **Book cover** (`box-shadow: 0 1px 0 rgba(0, 0, 0, .06), 0 16px 32px -20px rgba(6, 26, 22, .5)`): covers on the books page; on hover a 3px orange ring is added.

### Named Rules
**The Paper Veil Rule.** Text on the photograph sits under a cool paper veil that is strongest at the masthead and the text corner and clear elsewhere. A dark photo (autumn, Halloween) gets the stronger veil; a small photo (spring) is shown softened rather than stretched sharp. Text that runs past the veil (the hero release facts, the reference guides on the docs front page) sits on a translucent paper panel under a 1px orange rule.

**The Low Sheet Rule.** Shadows are long, soft and negative-spread, so a sheet reads as paper resting on a ground. No hard offset shadows, no card stacks.

## Shapes

Corners are square: 2px on buttons, sheets, code, fields, images and chips; 3px on beads (the tree's components, the version plate, tags, letter, lesson and step numbers, the lit rail entry). Nothing is rounder.

The ribbon is the recurring form. Drawn in SVG on the homepage it is a mitred band whose diagonal runs show the reverse side; drawn in CSS it is a 5 to 7px left border with a bottom border into each item and a 2px inner radius at the fold, with 3px runs for nested levels. A supported line carries a 16 x 5px run of ribbon before the word Supported.

Rules are structural: a 2px ink rule opens every list, table, index, fact row and homepage list; 1px hairlines separate rows; a 1px or 2px orange rule opens asides, the release highlights, the quick start sheet, search results and the panels on the photograph.

## Components

### Buttons
Few and orange: one action per section.
- **Shape:** square corners (2px).
- **Primary:** orange fill, ink text, Alegreya Sans 700 at 1.0625rem, 13px by 18px. The homepage's one is Get started, to the quick start.
- **Hover / Focus:** fill moves to `ribbon-text` over .15s; focus is a 2px `ribbon-deep` outline at 3px offset.
- **Copy:** a small orange button over a code sample, in the label row of the Maven dependency and the quick start, and in a code-ground bar that the documentation adds above every code block.
- **Jump lists:** Markdown button bars render as a ruled index of serif link labels, not as buttons.

### Beads
The components on the ribbon. Monospace or serif label in a 1px orange border, 3px corners, paper fill. Hover, focus or the current item fills orange. The root bead is always filled. Used for the tree's components, the version plate, the kind of a documentation page, A–Z letters, the numbers of lessons and quick start steps, and the search shortcut key.

### Tags
Small labels beside a line or a post: Alegreya SC in a 1px bordered bead. **LTS** and **Current** are the roles of the supported lines and are marked the same way everywhere they appear (the hero, the release lines table, a line's facts, the docs reference guides): an orange edge, ink text, beside the line's name or version. End of life and post kinds have a `field-stroke` edge and soft ink; Security fixes are in `ribbon-deep`.

### Inputs / Fields
- **Style:** paper fill, 1px `field-stroke` border, 2px corners, 44px tall (52px for the large documentation search), Alegreya Sans or mono text.
- **Hover:** border moves to `ink-soft`.
- **Focus:** border in `ribbon-deep` with a 2px `ribbon-deep` outline.
- **Selects:** native appearance removed, a small `ribbon-deep` chevron drawn in SVG.

### Cards / Containers
- **Sheets:** paper on a tint, cloth or photo ground, no border, square corners, the low sheet shadow, 12 to 20px padding. Used for the quick start, the documentation search and the code sheets of the tree.
- **Asides:** blockquotes, version notes and end-of-life notes on the pale tint with a 1px orange top rule.

### Navigation
- **Masthead:** lies on the photograph. Alegreya Sans 500 at 1.0625rem, ink. Hover shows a `ribbon-deep` underline; the current section (or the section of a page's breadcrumb) carries a 4px orange underline at a deep offset. The ASF feather with "ASF" and the GitHub mark with "GitHub" close the menu, set off from each other by a hairline; below 600px the marks stand alone. On the homepage the menu is centred without the brand; elsewhere the mark and the serif wordmark sit left.
- **Version plate:** beside the wordmark, the supported lines as two beads on one string, "11.0 | LTS 10", each linking to its line page; the line whose page is open is the lit bead. The homepage leaves it out from 1000px up, where the hero's release panel is in the first screen; on phones it stays, centred above the sections.
- **Rail:** the page's sections hang from the ribbon, which drops from the photograph's edge. Entries are Alegreya Sans in `ink-soft`; hover shows the orange wash; the section in view is a lit bead.
- **Breadcrumb:** the section above a page's title in small capitals, `ribbon-deep` links.
- **Footer:** cloth field: a sitemap of the site and the ASF links under small-caps headings in `ribbon-text`, paper links with orange underlines, the ASF logo on a paper tile beside the legal line in lichen.
- **Touch:** under `pointer: coarse` every menu link, plate segment, footer link, link row and rail entry is at least 44px tall.

### Links
Inherit the text color with a 1.5px `ribbon-deep` underline at .22em offset that thickens to 3px on hover. Titles in lists hide the underline until hover; long title lists keep a 1px underline.

### Component Tree (signature)
On cloth: the Java sheet left, the markup sheet right, beads on the ribbon between, thin threads joining each Java line to its tag on the same row. It is the homepage's "how it works", in place of a static code pair. The ribbon unrolls once from the top over 1.4s (`cubic-bezier(.16, 1, .3, 1)`) when the tree comes into view; pointing at or focusing a bead lights its path and its Java and HTML lines with the orange wash and dims the rest. Reduced motion shows it drawn complete. Below 1240px, and without JavaScript, the same tree is a nested list with the ribbon drawn in CSS down the left, each component's Java line above its tag. Three links follow: How Wicket works, Components and markup, and the running examples.

### How Wicket works (/start/overview.html)
The component tree grown in seven steps, from one HTML file to a tested page with Ajax under the Content Security Policy, on one cloth field under the page's title band. A rail of seven numbered beads at the top chooses the step: the ribbon runs along it up to the step shown, a thread runs on ahead. On wide screens with JavaScript one step shows at a time, its address `#step-N`, so the back button walks back through the steps; each step's heading and text sit above its loom, ending in the guide page that explains the step and a Next link. Every step is a loom like the homepage's, generated from `_data/how.yml` by `_plugins/loom.rb`: a line no earlier step had carries a + in its sheet's margin and briefly holds the wash, new beads slide in and the ribbon draws out into them over .8s. Each step lights what it is about while nothing is pointed at, with the beads on the way to it at full strength. A tag that waits for its component is a dashed bead off the ribbon; a word on a bead (the nonce on the Ajax link) is a small cloth chip. Below 1240px and without JavaScript the steps follow each other, each tree as a list with its files, and the rail is their table of contents. Reduced motion shows every step drawn complete.

### Seasonal Photograph
One element in two uses: behind the homepage hero and behind every page title. The season or dated occasion comes from `_data/seasons.yml`; without JavaScript a page shows the season of the month it was built in. Credits sit in a small cloth chip in the photo's corner (on phones, as a line on paper under the title). Review builds with `season_selector: true` add a season selector chip beside the credit; production builds do not show it.

### Release Facts (homepage)
On a translucent paper panel under a 1px orange top rule in the hero: the Current and the LTS line as their version in bold serif figures with their tag and "supported until …", a line with a `brief` in `_data/highlights.yml` with that one sentence of what is new under it in ink, then the lines that reached end of life with "How to upgrade" (to the upgrade paths), then "Release lines and support" (to /versions/). No scheduled releases. The full release lines live on /versions/ as a ruled table grouped under small-caps headings: Supported, Scheduled, End of life.

### Blog Lists
Featured posts on /news/ are columns under an ink rule: the date in small capitals, the serif title, a line of summary. On the homepage the same posts are rows: date left, title and summary right. Release announcements and archives are dated rows with hairlines.

### Built with Wicket
Screenshots from the Built with Wicket feed as low sheets on the tint, three at a time in a carousel without autoplay; the arrows are paper squares with a drawn `ribbon-deep` chevron and the dots are beads. On phones it is a swipeable strip.

## Do's and Don'ts

### Do:
- **Do** draw hierarchy with the ribbon: a left run and a folded elbow into each child, in `ribbon` at 5 to 7px.
- **Do** open lists, tables and indexes with a 2px ink rule and separate rows with 1px `rule` hairlines.
- **Do** set dates and labels in Alegreya SC, in `ribbon-deep` or `ink-soft`.
- **Do** put the season's photograph behind the title of every new page, through `_includes/season-photo.html` inside the page's title band.
- **Do** keep corners at 2px, and 3px for beads.
- **Do** use `ribbon-deep` for orange text on paper and `ribbon-text` on cloth.
- **Do** mark LTS and Current the same way, as tags beside the line.
- **Do** use plain words for release facts: Supported, End of life, Scheduled, LTS, Current, how to upgrade.

### Don't:
- **Don't** fill panels, headings or large areas with orange; it is the ribbon, a rule, a bead or the one action.
- **Don't** use cream, warm white or pure white as a ground.
- **Don't** build feature-card grids; reasons are columns of text under an ink rule.
- **Don't** use hard offset shadows or stacked cards; sheets rest on the ground with the low sheet shadow.
- **Don't** put kickers or eyebrow labels above headings; small caps head the list or table below them, or name the section a page belongs to.
- **Don't** use icon fonts or glyph icons; the Wicket mark, the ASF logo and feather, the GitHub mark and the drawn chevrons are the only images in the interface.
- **Don't** round corners beyond 3px.
- **Don't** borrow railway words (board, departures, platform, route) for release facts.
