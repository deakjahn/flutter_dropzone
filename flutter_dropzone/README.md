Dropzone
========

A Flutter Web plugin to handle drag-and-drop (files) *into* Flutter. If you're interested in drag-and-drop *inside* a Flutter app, check out other packages like [dnd](https://pub.dev/packages/dnd).

It exposes a single platform view, `DropzoneView`: 

``` dart
DropzoneView(
  operation: DragOperation.copy,
  onCreated: (ctrl) => controller = ctrl,
  onLoaded: () => print('Zone loaded'),
  onError: (ev) => print('Error: $ev'),
  onDrop: (ev) => print('Drop: $ev'),
);
```

The view itself has no display, it's just the dropzone area. Use a `Stack` to put it into the background of other widgets that
provide your UI:

``` dart
Stack(
  children: [
    DropzoneView(...),
    Center(child: Text('Drop files here')),
  ],
)
```

## Using it in cross-platform apps

It's a federated plugin, meaning that it will compile in cross platform apps that contain both Android/iOS and Web code.
It will *not* function on the latter, the view will simply return an error text instead of a drop zone. Use `if (kIsWeb)` from
`import 'package:flutter/foundation.dart'` to only use it in Flutter Web. Still, the same app will still compile to
Android and iOS, without the usual `dart:html` errors (this is what federated plugins are for).

## Using the controller

There is a convenience function, `pickFiles()` on the controller returned by the view. It simply opens the usual File Open dialog
in the browser and lets the user pick some files. It has nothing to do with the drag-and-drop operation (although it is the other
possible way to select files) but by putting it into the web side of a federated plugin we can make sure it doesn't hurt
the compilation on other platforms.

Because the files returned are HTML File API references with serious limitations, they can't be converted to regular Dart
`File` objects. They are returned as `dynamic` objects and the controller has functions to extract information from these objects:

*  `Future<String> getFilename(dynamic htmlFile);`
*  `Future<int> getFileSize(dynamic htmlFile);`
*  `Future<String> getFileMIME(dynamic htmlFile);`
*  `Future<Uint8List> getFileData(dynamic htmlFile);`

You can't have a permanent link to the file. If you need to retain the full image data, use `getFileData()` to get the actual contents
and store it yourself into localStorage, IndexedDB, uploading to your server, whatever. You can get a temporary URL using:

*  `Future<String> createFileUrl(dynamic htmlFile);`
*  `Future<bool> releaseFileUrl(String fileUrl);`

but this will only be valid for the session. It's a regular URL, so you can use it to display the image the same way like loading
from a regular web URL. Release it when you're done with the image.