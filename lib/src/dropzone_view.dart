library dropzone_view;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/src/flutter_dropzone_plugin.dart';

typedef DropzoneViewCreatedCallback = void Function(DropzoneViewController controller);

// https://github.com/flutter/flutter/issues/30719
// https://developer.mozilla.org/en-US/docs/Web/API/HTML_Drag_and_Drop_API
// https://developer.mozilla.org/en-US/docs/Web/API/HTML_Drag_and_Drop_API/File_drag_and_drop

class DropzoneView extends StatefulWidget {
  final DragOperation operation;
  final List<String> mime;
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;
  final DropzoneViewCreatedCallback onCreated;
  final VoidCallback onLoaded;
  final ValueChanged<String> onError;
  final ValueChanged<String> onDrop;

  const DropzoneView({
    Key key,
    this.operation,
    this.mime,
    this.gestureRecognizers,
    this.onCreated,
    this.onLoaded,
    this.onError,
    this.onDrop,
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
      'mime': widget.mime,
    };
    return FlutterDropzonePlugin.instance.buildView(params, widget.gestureRecognizers, (viewId) {
      final ctrl = DropzoneViewController._create(viewId, widget);
      _controller.complete(ctrl);
      widget.onCreated?.call(ctrl);
      FlutterDropzonePlugin.instance.init(params, viewId: viewId);
    });
  }
}

class DropzoneViewController {
  final int viewId;
  final DropzoneView widget;

  DropzoneViewController._create(this.viewId, this.widget) : assert(FlutterDropzonePlugin.instance != null) {
    if (widget.onLoaded != null) {
      FlutterDropzonePlugin.instance //
          .onLoaded(viewId: viewId)
          .listen((_) => widget.onLoaded());
    }
    if (widget.onError != null) {
      FlutterDropzonePlugin.instance //
          .onError(viewId: viewId)
          .listen((msg) => widget.onError(msg.value));
    }
    if (widget.onDrop != null) {
      FlutterDropzonePlugin.instance //
          .onDrop(viewId: viewId)
          .listen((msg) => widget.onDrop(msg.value));
    }
  }

  Future<bool> setOperation(DragOperation operation) {
    return FlutterDropzonePlugin.instance.setOperation(operation, viewId: viewId);
  }

  Future<bool> setMIME(List<String> mime) {
    return FlutterDropzonePlugin.instance.setMIME(mime, viewId: viewId);
  }
}
