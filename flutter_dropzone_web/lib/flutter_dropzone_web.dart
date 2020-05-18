@JS('flutter_dropzone_web')
library flutter_dropzone_web;

import 'dart:async';
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter_dropzone_platform_interface/flutter_dropzone_platform_interface.dart';
import 'package:js/js.dart';

@JS('initialize')
external void _nativeInitialize(dynamic container, Function onLoaded, Function onError, Function onDrop);

@JS('setMIME')
external bool _nativeSetMIME(dynamic container, List<String> mime);

@JS('setOperation')
external bool _nativeSetOperation(dynamic container, String operation);

class FlutterDropzoneView {
  final int viewId;
  DivElement container;
  List<String> mime;
  DragOperation operation;

  FlutterDropzoneView(this.viewId) {
    container = DivElement()
      ..id = 'dropzone-container-$viewId'
      ..style.border = 'none'
      ..append(ScriptElement()..text = 'flutter_dropzone_web.triggerBuild($viewId);')
      ..addEventListener('build', (_) {
        if (mime != null) setMIME(mime);
        if (operation != null) setOperation(operation);
        _nativeInitialize(
          container,
          allowInterop(_onLoaded),
          allowInterop(_onError),
          allowInterop(_onDrop),
        );
      });
  }

  void init(Map<String, dynamic> params) {
    mime = params['mime'];
    operation = params['operation'];
  }

  Future<bool> setMIME(List<String> mime) async {
    return _nativeSetMIME(container, mime);
  }

  Future<bool> setOperation(DragOperation operation) async {
    return _nativeSetOperation(container, describeEnum(operation));
  }

  Future<List<dynamic>> pickFiles({@required int viewId}) {
    final completer = Completer<List<dynamic>>();

    final uploadInput = FileUploadInputElement();
    uploadInput.onChange.listen((e) {
      completer.complete(uploadInput.files);
    });
    uploadInput.click();

    return completer.future;
  }

  void _onLoaded() => FlutterDropzonePlatform.instance.events.add(DropzoneLoadedEvent(viewId));

  void _onError(String error) => FlutterDropzonePlatform.instance.events.add(DropzoneErrorEvent(viewId, error));

  void _onDrop(MouseEvent event, File data) => FlutterDropzonePlatform.instance.events.add(DropzoneDropEvent(viewId, data));
}
