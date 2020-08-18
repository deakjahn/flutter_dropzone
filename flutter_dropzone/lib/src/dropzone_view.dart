import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone_platform_interface/flutter_dropzone_platform_interface.dart';

typedef DropzoneViewCreatedCallback = void Function(DropzoneViewController controller);

// https://developer.mozilla.org/en-US/docs/Web/API/HTML_Drag_and_Drop_API
// https://developer.mozilla.org/en-US/docs/Web/API/HTML_Drag_and_Drop_API/File_drag_and_drop

class DropzoneView extends StatefulWidget {
  final DragOperation operation;
  final CursorType cursor;
  final List<String> mime;
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;
  final DropzoneViewCreatedCallback onCreated;

  /// Event called when the dropzone view has been loaded.
  final VoidCallback onLoaded;

  /// Event called if the dropzone view has an eror.
  final ValueChanged<String> onError;

  /// Event called when the dropzone view is hovered during a drag-drop.
  final VoidCallback onHover;

  /// Event called when the user drops a file onto the dropzone.
  final ValueChanged<dynamic> onDrop;

  /// Event called when the user leaves a dropzone.
  final VoidCallback onLeave;

  const DropzoneView({
    Key key,
    this.operation,
    this.cursor,
    this.mime,
    this.gestureRecognizers,
    this.onCreated,
    this.onLoaded,
    this.onError,
    this.onHover,
    @required this.onDrop,
    this.onLeave,
  }) : super(key: key);

  @override
  _DropzoneViewState createState() => _DropzoneViewState();
}

class _DropzoneViewState extends State<DropzoneView> {
  final _controller = Completer<DropzoneViewController>();

  @override
  Widget build(BuildContext context) {
    final params = <String, dynamic>{
      'operation': widget.operation,
      'cursor': widget.cursor,
      'mime': widget.mime,
    };
    return FlutterDropzonePlatform.instance.buildView(params, widget.gestureRecognizers, (viewId) {
      final ctrl = DropzoneViewController._create(viewId, widget);
      _controller.complete(ctrl);
      widget.onCreated?.call(ctrl);
      FlutterDropzonePlatform.instance.init(params, viewId: viewId);
    });
  }
}

class DropzoneViewController {
  final int viewId;
  final DropzoneView widget;

  DropzoneViewController._create(this.viewId, this.widget) : assert(FlutterDropzonePlatform.instance != null) {
    if (widget.onLoaded != null) {
      FlutterDropzonePlatform.instance //
          .onLoaded(viewId: viewId)
          .listen((_) => widget.onLoaded());
    }
    if (widget.onError != null) {
      FlutterDropzonePlatform.instance //
          .onError(viewId: viewId)
          .listen((msg) => widget.onError(msg.value));
    }
    if (widget.onHover != null) {
      FlutterDropzonePlatform.instance //
          .onHover(viewId: viewId)
          .listen((msg) => widget.onHover());
    }
    if (widget.onDrop != null) {
      FlutterDropzonePlatform.instance //
        .onDrop(viewId: viewId)
        .listen((msg) => widget.onDrop(msg.value));
    }
    if (widget.onLeave != null) {
      FlutterDropzonePlatform.instance //
        .onLeave(viewId: viewId)
        .listen((msg) => widget.onLeave());
    }
  }

  /// Specify the [DragOperation] while dragging the file.
  Future<bool> setOperation(DragOperation operation) {
    return FlutterDropzonePlatform.instance.setOperation(operation, viewId: viewId);
  }

  /// Specify the [CursorType] of the dropzone. [CursorType] is one the CSS cursor types.
  Future<bool> setCursor(CursorType cursor) async {
    return FlutterDropzonePlatform.instance.setCursor(cursor, viewId: viewId);
  }

  /// Specify the list of accepted MIME types.
  Future<bool> setMIME(List<String> mime) {
    return FlutterDropzonePlatform.instance.setMIME(mime, viewId: viewId);
  }

  /// Convenience function to display the browser File Open dialog.
  ///
  /// Set [multiple] to allow picking more than one file.
  /// Returns the list of files picked by the user.
  Future<List<dynamic>> pickFiles({bool multiple = false}) {
    return FlutterDropzonePlatform.instance.pickFiles(multiple, viewId: viewId);
  }

  /// Get the filename of the passed HTML file.
  Future<String> getFilename(dynamic htmlFile) {
    return FlutterDropzonePlatform.instance.getFilename(htmlFile, viewId: viewId);
  }

  /// Get the size of the passed HTML file.
  Future<int> getFileSize(dynamic htmlFile) {
    return FlutterDropzonePlatform.instance.getFileSize(htmlFile, viewId: viewId);
  }

  /// Get the MIME type of the passed HTML file.
  Future<String> getFileMIME(dynamic htmlFile) {
    return FlutterDropzonePlatform.instance.getFileMIME(htmlFile, viewId: viewId);
  }

  /// Create a temporary URL to the passed HTML file.
  ///
  /// When finished, the URL should be released using [releaseFileUrl()].
  Future<String> createFileUrl(dynamic htmlFile) {
    return FlutterDropzonePlatform.instance.createFileUrl(htmlFile, viewId: viewId);
  }

  /// Release a temporary URL previously created using [createFileUrl()].
  Future<bool> releaseFileUrl(String fileUrl) {
    return FlutterDropzonePlatform.instance.releaseFileUrl(fileUrl, viewId: viewId);
  }

  /// Get the contents of the passed HTML file.
  Future<Uint8List> getFileData(dynamic htmlFile) {
    return FlutterDropzonePlatform.instance.getFileData(htmlFile, viewId: viewId);
  }
}
