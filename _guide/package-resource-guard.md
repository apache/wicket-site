---
title: Control which package resources are served
type: howto
topic: security
summary: Allow or block files on the classpath that browsers may request as package resources, with patterns on SecurePackageResourceGuard.
since: 10
apis: [IPackageResourceGuard, SecurePackageResourceGuard, PackageResourceGuard, ResourceSettings]
keywords: [classpath files, file extensions, pdf, mp4, json, access denied to shared resource, whitelist, static files, addPattern]
order: 70
source: [security/security_7.adoc]
---

You need this when a browser gets "access denied" for a file you serve from a Java package, or when you want to make sure a file next to your classes can never be downloaded. Every request for a package resource passes the package resource guard first. The default guard, `SecurePackageResourceGuard`, refuses everything that is not explicitly allowed.

## Know what is allowed by default

| Kind | Extensions |
|---|---|
| Scripts and styles | `.js`, `.css`, `.map` |
| Images | `.png`, `.jpg`, `.jpeg`, `.gif`, `.ico`, `.cur`, `.bmp`, `.svg`, `.avif` |
| Fonts | `.eot`, `.ttf`, `.woff`, `.woff2` |
| Text and other | `.html`, `.txt`, `.swf` |

Some files are refused even when their extension is allowed:

- `.properties`, `.class` and `.java` files, and files named `applicationContext.xml` or `log4j.xml`;
- an `.html` file next to a class of the same name, because that is the markup of a component;
- paths containing `..`, unless you configured a parent folder placeholder in the resource settings;
- files in the root of the classpath.

When the guard refuses a file, Wicket logs a warning such as "Access denied to shared (static) resource because of the file extension".

## Allow more files

Add a pattern to the guard in `init()`:

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();
    if (getResourceSettings().getPackageResourceGuard()
            instanceof SecurePackageResourceGuard guard) {
        guard.addPattern("+com/example/docs/*.pdf");
    }
}
```

The pattern above allows PDF files in the package `com.example.docs` and nowhere else.

Common formats missing from the defaults are video and audio (`.mp4`, `.webm`, `.mp3`) and `.webp` images. Allow them the same way, for example `guard.addPattern("+com/example/media/*.webp")`.

## Write a pattern

| Pattern | Matches |
|---|---|
| `+*.pdf` | Every PDF file, in any package |
| `+com/example/docs/*.pdf` | PDF files directly in `com/example/docs` |
| `+com/example/*/*.pdf` | PDF files exactly one level below `com/example` |
| `+com/example/**/*.pdf` | PDF files in `com/example` or any package below it |
| `+**/public/*.pdf` | PDF files in any package whose last part is `public` |
| `-**/secret.txt` | Blocks `secret.txt` everywhere |

The rules:

- A pattern starts with `+` to allow or `-` to block.
- `*` stands for any characters within one file or directory name, `**` for any number of directories.
- A pattern without a `/` is matched against the file name only. A pattern with a `/` is matched against the whole path from the classpath root, such as `com/example/docs/manual.pdf`.
- Patterns are checked from the last added to the first, and the first one that matches decides. Add a blocking pattern after the allowing pattern it should override.

Avoid patterns like `+*.pdf` that allow an extension everywhere: any PDF on the classpath, including those in libraries, becomes downloadable. Name the package.

## Block a file the defaults allow

```java
guard.addPattern("-com/example/internal/**/*.html");
```

## Replace the guard

`getResourceSettings().setPackageResourceGuard(guard)` installs your own `IPackageResourceGuard`. Extend `SecurePackageResourceGuard` to keep the default rules, or `PackageResourceGuard` for a guard that applies only the fixed refusals listed above and allows every other file.

[Serve files from your Java packages]({{ site.baseurl }}/docs/package-resources.html) shows how to reference package resources from your components.
