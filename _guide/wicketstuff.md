---
title: WicketStuff
type: reference
topic: integration
summary: The community modules of the WicketStuff project, what each one adds to Wicket, and how to add one to a Maven build.
since: 10
apis: []
keywords: [community components, third party modules, extensions, add-ons, wicketstuff-core, jQuery UI, Kendo UI, Select2, TinyMCE, Google Maps, REST, Shiro, page store, Redis, Hazelcast, Excel export]
order: 90
source: [wicketstuff.adoc, wicketstuff/wicketstuff_1.adoc, wicketstuff/wicketstuff_2.adoc, wicketstuff/wicketstuff_3.adoc, wicketstuff/wicketstuff_4.adoc, wicketstuff/wicketstuff_5.adoc, wicketstuff/wicketstuff_6.adoc, wicketstuff/wicketstuff_7.adoc]
---

WicketStuff is a collection of Wicket modules written and maintained by the Wicket community, outside the Apache Wicket project. The sources, issue tracker and wiki are at [github.com/wicketstuff/core](https://github.com/wicketstuff/core). Most modules come with an examples project next to them in the repository.

## Add a module

The modules have the group id `org.wicketstuff`. WicketStuff releases follow the version numbers of Wicket: use the WicketStuff release with the same major version as your Wicket release.

```xml
<dependency>
    <groupId>org.wicketstuff</groupId>
    <artifactId>wicketstuff-select2</artifactId>
    <version>${wicketstuff.version}</version>
</dependency>
```

To keep the versions of several modules in line, import the BOM:

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.wicketstuff</groupId>
            <artifactId>wicketstuff-bom</artifactId>
            <version>${wicketstuff.version}</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

WicketStuff follows Wicket's releases after they appear. When you move to a new major version of Wicket, check that the modules you use have been released for it.

## Modules

The tables list the modules in the WicketStuff repository by artifact id.

### JavaScript widgets

| Artifact | Adds |
|---|---|
| `wicketstuff-jquery-ui`, `wicketstuff-jquery-ui-plugins`, `wicketstuff-jquery-ui-calendar` | Components and behaviors for jQuery UI widgets: dialogs, date pickers, autocomplete, sliders, tabs, a calendar. |
| `wicketstuff-kendo-ui` | Components for Kendo UI widgets, from the same project as jQuery UI. |
| `wicketstuff-select2` | Select boxes with search, tagging and Ajax loading of options, based on Select2. |
| `wicketstuff-selectize` | Select boxes based on Selectize. |
| `wicketstuff-autocomplete-tagit` | Tag input with autocompletion, based on Tag-it. |
| `wicketstuff-tinymce6` | WYSIWYG HTML editing for text areas with TinyMCE 6, through `TinyMceBehavior`. |
| `wicketstuff-datatables` | Tables based on the DataTables jQuery plugin. |
| `wicketstuff-clipboardjs` | Copy text to the clipboard with clipboard.js. |
| `wicketstuff-input-events` | Bind keyboard shortcuts and other input events to components. |
| `modalx` | Base classes for modal windows and modal forms. |
| `wicketstuff-progressbar` | A progress bar for long-running tasks. |

### Maps and charts

| Artifact | Adds |
|---|---|
| `wicketstuff-gmap3` | Google Maps with the `GMap` component. |
| `wicketstuff-openlayers3` | Interactive maps with OpenLayers. |
| `jqplot` | Charts with jqPlot. |
| `wicketstuff-flot` | Charts with Flot. |

### Grids and data

| Artifact | Adds |
|---|---|
| `wicketstuff-inmethod-grid` | `DataGrid` and `TreeGrid`: grids with resizable and reorderable columns, selection and inline editing. |
| `wicketstuff-editable-grid` | A data table whose rows can be edited, added and deleted in place. |
| `wicketstuff-poi` | Export tables to Excel with Apache POI. |
| `wicketstuff-jasperreports` | Render JasperReports reports as resources. |
| `wicketstuff-dashboard-core`, `wicketstuff-dashboard-widgets` | A dashboard of movable widgets. |

### Application infrastructure

| Artifact | Adds |
|---|---|
| `wicketstuff-annotation` | Mount pages with the `@MountPath` annotation instead of `mountPage()` calls. |
| `wicketstuff-restannotations`, `wicketstuff-restannotations-json` | REST APIs as Wicket resources, with methods mapped by annotations. |
| `wicketstuff-rest-lambda` | REST endpoints defined with lambdas. |
| `wicketstuff-lambda-components` | Factory methods that create links and buttons from lambdas. |
| `wicketstuff-lazymodel` | Type-safe property models checked by the compiler. |
| `wicketstuff-urlfragment` | Read and write parameters in the URL fragment, for bookmarkable Ajax state. |
| `wicketstuff-sitemap-xml` | Generate *sitemap.xml* files for search engines. |
| `wicketstuff-htmlcompressor` | Compress the rendered markup with htmlcompressor. |
| `wicketstuff-annotationeventdispatcher` | Deliver [Wicket events]({{ site.baseurl }}/docs/send-events.html) to methods marked with an annotation. |
| `wicketstuff-mbeanview` | A panel that shows and operates the application's JMX MBeans. |

### Integration, security and storage

| Artifact | Adds |
|---|---|
| `wicketstuff-javaee-inject` | Inject EJBs, JNDI resources and persistence units; see [Inject EJBs]({{ site.baseurl }}/docs/ejb.html). |
| `wicketstuff-springreference` | A serializable reference to Spring beans, for places where `@SpringBean` does not work. |
| `wicketstuff-shiro` | Authentication and authorization with Apache Shiro. |
| `wicketstuff-datastore-redis`, `-hazelcast`, `-cassandra`, `-memcached`, `-ignite` | Page stores that keep pages in a shared data store, for clusters. See [Configure the page store]({{ site.baseurl }}/docs/configure-page-store.html). |
| `wicketstuff-serializer-fast2` | A faster page serializer based on FST. |
| `wicketstuff-serializer-kryo2` | A page serializer based on Kryo. Its own documentation advises against production use. |
