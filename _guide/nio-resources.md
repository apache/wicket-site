---
title: Serve files with NIO
type: howto
topic: resources
summary: Serve files from the file system or from inside a ZIP archive through java.nio.file.Path with FileSystemResourceReference and FileSystemResource, including byte ranges for media.
since: 10
apis: [FileSystemResourceReference, FileSystemResource, FileSystemPathService, FileSystemJarPathService, Video]
keywords: [java.nio, Path, file system, serve file from disk, zip file, jar file, uploaded files, media streaming, range request, FileSystemProvider]
order: 140
source: [resources/resources_16.adoc]
---

Use `FileSystemResourceReference` when the files you serve live outside the web application and the classpath: uploads on a shared disk, generated reports in a folder, or media inside a ZIP archive. It works with any `java.nio.file.Path`, so the same code serves a file on disk or an entry in an archive.

## Mount a folder of files

Write a reference that builds the path from a parameter, and keep one instance of it:

*MediaReference.java*

```java
public class MediaReference extends FileSystemResourceReference {

    public static final MediaReference INSTANCE = new MediaReference();

    private static final Path FOLDER = Paths.get("/srv/example/media");

    private MediaReference() {
        super(MediaReference.class, "media");
    }

    @Override
    public IResource getResource() {
        return new FileSystemResource() {
            @Override
            protected ResourceResponse newResourceResponse(Attributes attributes) {
                String name = attributes.getParameters().get("name").toString("");
                if (!name.matches("[\\w-]+(\\.[\\w-]+)*")) {
                    return new ResourceResponse().setError(404);
                }
                return createResourceResponse(attributes, FOLDER.resolve(name));
            }
        };
    }
}
```

Mount it with a placeholder for the file name:

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();
    mountResource("/media/${name}", MediaReference.INSTANCE);
}
```

`/media/intro.mp4` now serves `/srv/example/media/intro.mp4`. The response gets the content type from the file name and supports HTTP range requests, so a video player can seek, and Wicket streams the file instead of loading it into memory.

The name comes from the URL. Check it before you use it in a path, as the example does, so that a request cannot reach outside the folder with `..` or a slash.

## Serve an entry from a ZIP archive

`FileSystemResourceReference.getPath(URI)` creates the path for a URI and opens the file system it needs. For a `jar:` URI it opens the archive as a file system and keeps it open for the application. Replace the last line of `newResourceResponse` with:

```java
try {
    URI uri = URI.create("jar:file:///srv/example/media/videos.zip!/videos/" + name);
    return createResourceResponse(attributes, FileSystemResourceReference.getPath(uri));
} catch (IOException | URISyntaxException e) {
    throw new WicketRuntimeException("Cannot open " + name, e);
}
```

## Play a file in a page

Give a media component the reference and the file name as a parameter:

```java
add(new Video("intro", MediaReference.INSTANCE, new PageParameters().add("name", "intro.mp4")));
```

```html
<video wicket:id="intro" controls></video>
```

The `src` becomes `/media/intro.mp4`. A `ResourceLink` with the same reference and parameters offers the file as a download.

`FileSystemResourceReference` also has a constructor that takes the path directly, `new FileSystemResourceReference("intro", path)`. That reference keeps the `Path` in a field, and `Path` is not serializable, so a stateful page that holds it cannot be stored. Prefer a reference that builds the path while it responds, as above.

The default Content Security Policy sets no `media-src` directive and falls back to `default-src 'none'`, which blocks video and audio. Allow your own origin in `init()`:

```java
getCspSettings().blocking().add(CSPDirective.MEDIA_SRC, CSPDirectiveSrcValue.SELF);
```

## Support another file system

`getPath` asks every `FileSystemPathService` found with `java.util.ServiceLoader` whether it handles the URI, and falls back to `Paths.get(uri)`. Wicket's own `FileSystemJarPathService` handles `jar:` URIs. To serve from a file system of your own, implement `FileSystemPathService` with `isResponsible(URI)` and `getPath(URI, Map<String, String>)`, and list the class in `META-INF/services/org.apache.wicket.resource.FileSystemPathService`. The file system itself is a standard `java.nio.file.spi.FileSystemProvider`.
