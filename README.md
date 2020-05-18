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