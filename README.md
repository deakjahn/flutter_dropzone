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
