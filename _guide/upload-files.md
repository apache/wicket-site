---
title: Upload files
type: howto
topic: forms
summary: Let users upload one or more files with FileUploadField, limit their size and number, and show upload progress.
since: 10
apis: [FileUploadField, FileUpload, MultiFileUploadField, UploadProgressBar, Form]
keywords: [file upload, multipart, input type file, max size, upload limit, attachment, multiple files, progress bar]
order: 90
source: [forms2/forms2_8.adoc]
---

You need this when a form takes a file from the user, such as an avatar or a document. The browser sends the file along with the form as a multipart request; Wicket switches the form to multipart as soon as it contains a `FileUploadField`.

## Upload a file

Add a `FileUploadField` to the form and bind it to `<input type="file">`. In `onSubmit()`, ask the field for the uploaded file.

*UploadPage.java*

```java
FileUploadField fileField = new FileUploadField("file");
fileField.setRequired(true);

Form<Void> form = new Form<>("form") {
    @Override
    protected void onSubmit() {
        FileUpload upload = fileField.getFileUpload();
        try (InputStream in = upload.getInputStream()) {
            documentService.store(upload.getClientFileName(), upload.getContentType(), in);
            success("Uploaded " + upload.getClientFileName());
        } catch (IOException e) {
            error("Upload failed");
        }
    }
};
form.add(fileField);
form.add(new FeedbackPanel("feedback"));
add(form);
```

*UploadPage.html*

```html
<form wicket:id="form">
    <div wicket:id="feedback"></div>
    <input type="file" wicket:id="file">
    <button type="submit">Upload</button>
</form>
```

`getFileUpload()` returns `null` when the user did not pick a file. A `FileUpload` gives you:

| Method | Returns |
|---|---|
| `getClientFileName()` | the file name as the browser sent it |
| `getContentType()` | the content type as the browser sent it |
| `getSize()` | the size in bytes |
| `getInputStream()` | the content as a stream |
| `getBytes()` | the content as a byte array |
| `writeTo(File)` | writes the content to a file |
| `writeToTempFile()` | writes the content to a new temporary file and returns it |
| `getDigest(String)`, `getMD5()` | a checksum of the content |

Handle the upload in the same request. At the end of the request Wicket closes the streams of the upload and sets the field's model back to `null`, so do not keep the `FileUpload` for later.

The client file name and content type come from the browser. Do not use them as a path on your server without checking them.

## Upload several files at once

Add the `multiple` attribute to the input. The browser then lets the user pick several files, and `getFileUploads()` returns them all:

```html
<input type="file" multiple wicket:id="files">
```

```java
for (FileUpload upload : filesField.getFileUploads()) {
    // store each file
}
```

`MultiFileUploadField` offers a list in which the user adds files one by one and can remove them before submitting. Its model holds the collection of uploads.

## Limit the size of uploads

Set the limits on the form. A request that exceeds them fails before your `onSubmit()` runs, and the form reports an error message instead.

```java
form.setMaxSize(Bytes.megabytes(10));     // whole request
form.setFileMaxSize(Bytes.megabytes(2));  // each file
form.setFileCountMax(5);                  // number of files
```

Set a default for every form in the application in `init()`:

```java
getApplicationSettings().setDefaultMaximumUploadSize(Bytes.megabytes(10));
```

The messages use the keys `uploadTooLarge`, `uploadSingleFileTooLarge`, `uploadTooManyFiles` and, for other upload errors, `uploadFailed`, with the variables `${maxSize}`, `${fileMaxSize}` and `${fileCountMax}`. Override them in your properties files like any other message. Your servlet container may have its own limit on the request size as well.

## Show upload progress

`UploadProgressBar` from wicket-extensions shows how far a large upload has come. Turn on progress tracking in the application and add the bar to the form:

```java
// in WicketApplication.init()
getApplicationSettings().setUploadProgressUpdatesEnabled(true);
```

```java
form.add(new UploadProgressBar("progress", form, fileField));
```

```html
<div wicket:id="progress"></div>
```

## React when the user picks a file

`FilesSelectedBehavior` sends the name, size and type of the selected files to the server over Ajax, before the form is submitted. Use it to warn about a file that is too large:

```java
fileField.add(FilesSelectedBehavior.onSelected((target, files) -> {
    for (FileDescription file : files) {
        // check file.getFileSize(), file.getFileName(), file.getMimeType()
    }
}));
```
