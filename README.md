Dropzone
========

A Flutter Web plugin to handle drag-and-drop (files) into Flutter. If you're interested in drag-and-drop inside a Flutter app, check out other packages like https://pub.dev/packages/dnd.

Right now, nothing fancy. It exposes a single platform view, `DropzoneView`: 

```
  DropzoneView(
    operation: DragOperation.copy,
    onCreated: (ctrl) => controller = ctrl,
    onLoaded: () => print('Zone loaded'),
    onError: (ev) => print('Error: $ev'),
    onDrop: (ev) => print('Drop: $ev'),
  );
```

It's a federated plugin, meaning that it will compile in cross platform apps that contain both Android/iOS and Web code.
It will *not* function on the latter, the view will simply return an error text instead of a drop zone. Use `if (kIsWeb)` from
`import 'package:flutter/foundation.dart'` to only use it in Flutter Web. Still, the same app will still compile to
Android and iOS, without the usual `dart:html` errors (this is what federated plugins are for).

There is a convenience function, `pickFiles()` on the controller returned by the view. It simply opens the usual File Open dialog
in the browser and lets the user pick some files. It has nothing to do with the drag-and-drop operation (although it is the other
possible way to select files) but by putting it into the web side of a federated plugin we can make sure it doesn't hurt
the compilation on other platforms.

Because the files returned are HTML File API references with serious limitations, they cannot be converted to regular Dart
`File` objects. They are returned as `dynamic` objects and the controller has functions to extract information from these objects:

*  `Future<String> getFilename(dynamic htmlFile);`
*  `Future<int> getFileSize(dynamic htmlFile);`
*  `Future<String> getFileMIME(dynamic htmlFile);`
*  `Future<String> createFileUrl(dynamic htmlFile);`
*  `Future<bool> releaseFileUrl(String fileUrl);`
*  `Future<Uint8List> getFileData(dynamic htmlFile);`