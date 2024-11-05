Dropzone
========

A Flutter Web plugin to handle drag-and-drop (files) *into* Flutter. If you're interested in drag-and-drop *inside* a Flutter app, check out other packages like [dnd](https://pub.dev/packages/dnd).

It exposes a single platform view, `DropzoneView`: 

```dart
DropzoneView(
  operation: DragOperation.copy,
  cursor: CursorType.grab,
  onCreated: (DropzoneViewController ctrl) => controller = ctrl,
  onLoaded: () => print('Zone loaded'),
  onError: (String? ev) => print('Error: $ev'),
  onHover: () => print('Zone hovered'),
  onDropFile: (DropzoneFile file) => print('Drop: ${file.webFile}'),
  onDropString: (String s) => print('Drop: $s'),
  onDropFiles: (List<DropzoneFile> files) => print('Drop multiple: $files'),
  onDropStrings: (List<String> strings) => print('Drop multiple: $strings'),
  onLeave: () => print('Zone left'),
);
```

The view itself has no display, it's just the dropzone area. Use a `Stack` to put it into the background of other widgets that
provide your UI:

```dart
Stack(
  children: [
    DropzoneView(...),
    Center(child: Text('Drop files here')),
  ],
)
```

## Using the controller

Because the files returned are HTML File API references with serious limitations, they can't be converted to regular Dart
`File` objects. They are returned as `DropzoneFileInterface` objects and the controller has functions to extract information from these objects:

*  `Future<String> getFilename(DropzoneFileInterface file);`
*  `Future<int> getFileSize(DropzoneFileInterface file);`
*  `Future<String> getFileMIME(DropzoneFileInterface file);`
*  `Future<DateTime> getFileLastModified(DropzoneFileInterface file);`
*  `Future<Uint8List> getFileData(DropzoneFileInterface file);`
*  `Stream<List<int>> getFileStream(DropzoneFileInterface file);`

You can't have a permanent link to the file (and no file path, either). If you need to retain the full file data, use `getFileData()`
to get the actual contents and store it yourself into localStorage, IndexedDB, uploading to your server, whatever.
You can get a temporary URL using:

*  `Future<String> createFileUrl(DropzoneFileInterface file);`
*  `Future<bool> releaseFileUrl(String fileUrl);`

but this will only be valid for the session. It's a regular URL, so you can use it to display the image the same way like loading
from a regular web URL. Release it when you're done with the image.

There is a convenience function, `pickFiles()` on the controller returned by the view. It simply opens the usual File Open dialog
in the browser and lets the user pick some files. It has nothing to do with the drag-and-drop operation (although it is the other
possible way to select files) but by putting it into the web side of a federated plugin we can make sure it doesn't hurt the
compilation on other platforms.

*  `Future<List<DropzoneFile>> pickFiles(bool multiple, List<String> mime);`

## Using it in cross-platform apps

It's a federated plugin, meaning that it will compile in cross platform apps that contain both Android/iOS and Web code.
It will *not* function on the former, the view will simply return an error text instead of a drop zone. Use `if (kIsWeb)` from
`import 'package:flutter/foundation.dart'` to only use it in Flutter Web. Still, the same app will still compile to
Android and iOS, without the usual `dart:html` errors (this is what federated plugins are for).

## Breaking changes

4.2.0 had to introduce another breaking change, sorry. While 4.1.0 solved the problem for web users, it created a regression
for some other people who author multiplatorm apps where not all variants are web-based. Instead of returning a `web.File` directly,
the `onDrop` variants now return a `DropzoneFileInterface`. You can go on accessing its properties as before, so you might not even note
the difference.

4.1.0 deprecates `onDrop` and all other functions using `dynamic` type because the newer Flutter JS support enforces
stricter type checking. `onDrop` will be removed in a coming version. Use `onDropFile` and `onDropString` instead.

4.0.0 is a breaking change because Flutter is actively working on the underlying web support and we're trying to follow suit.
See: https://github.com/deakjahn/flutter_dropzone/issues/78

3.0.0 had to be a breaking change because a bug I reported earlier was fixed in Flutter 2.5 stable: https://github.com/flutter/flutter/issues/56181

Previously, as a workaround, the plugin had its own modified version of `HtmlElementView` but with the fix, it's no longer necessary. However, leaving it out would break
the functioning of the plugin for people how haven't yet moved on to 2.5. You have to stay with the latest 2.0.x version of `flutter_dropzone` if you're not yet ready to upgrade
your Flutter for any reason.