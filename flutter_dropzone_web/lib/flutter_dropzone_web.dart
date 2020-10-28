@JS('flutter_dropzone_web')
library flutter_dropzone_web;

import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_dropzone_platform_interface/flutter_dropzone_platform_interface.dart';
import 'package:js/js.dart';

class FlutterDropzoneView {
  final int viewId;
  DivElement container;
  List<String> mime;
  DragOperation operation;
  CursorType cursor;

  FlutterDropzoneView(this.viewId) {
    container = DivElement()
      ..id = 'dropzone-container-$viewId'
      ..style.pointerEvents = 'auto'
      ..style.border = 'none'
      ..style.animationName =
          'dropzoneReady' // idea from https://keithclark.co.uk/articles/working-with-elements-before-the-dom-is-ready/
      ..style.animationDuration = '0.001s';
    EventListener listener;
    listener = (event) {
      container.removeEventListener('animationstart', listener);
      _nativeCreate(
        container,
        allowInterop(_onLoaded),
        allowInterop(_onError),
        allowInterop(_onHover),
        allowInterop(_onDrop),
        allowInterop(_onLeave),
      );
      if (mime != null) setMIME(mime);
      if (operation != null) setOperation(operation);
      if (cursor != null) setCursor(cursor);
    };
    container.addEventListener('animationstart', listener);

    if (!const bool.fromEnvironment('FLUTTER_WEB_USE_SKIA', defaultValue: false))
      container.append(
        StyleElement()
          ..innerText =
              '@keyframes dropzoneReady {from { clip: rect(1px, auto, auto, auto); } to { clip: rect(0px, auto, auto, auto); }}',
      );
  }

  void init(Map<String, dynamic> params) {
    mime = params['mime'];
    operation = params['operation'];
    cursor = params['cursor'];
  }

  Future<bool> setMIME(List<String> mime) async {
    return _nativeSetMIME(container, mime);
  }

  Future<bool> setOperation(DragOperation operation) async {
    return _nativeSetOperation(container, describeEnum(operation));
  }

  Future<bool> setCursor(CursorType cursor) async {
    return _nativeSetCursor(container, describeEnum(cursor).toLowerCase().replaceAll('_', '-'));
  }

  Future<List<dynamic>> pickFiles(bool multiple) {
    final completer = Completer<List<dynamic>>();
    final picker = FileUploadInputElement();
    picker.multiple = multiple;
    picker.onChange.listen((_) => completer.complete(picker.files));
    picker.click();
    return completer.future;
  }

  Future<String> getFilename(File file) async {
    return file.name;
  }

  Future<int> getFileSize(File file) async {
    return file.size;
  }

  Future<String> getFileMIME(File file) async {
    return file.type;
  }

  Future<String> createFileUrl(File file) async {
    return Url.createObjectUrlFromBlob(file);
  }

  Future<bool> releaseFileUrl(String fileUrl) async {
    Url.revokeObjectUrl(fileUrl);
    return true;
  }

  Future<Uint8List> getFileData(File file) async {
    final completer = Completer<Uint8List>();
    final reader = FileReader();
    reader.readAsArrayBuffer(file);
    reader.onLoad.listen((_) => completer.complete(reader.result));
    return completer.future;
  }

  void _onLoaded() => FlutterDropzonePlatform.instance.events.add(DropzoneLoadedEvent(viewId));

  void _onError(String error) => FlutterDropzonePlatform.instance.events.add(DropzoneErrorEvent(viewId, error));

  void _onHover(MouseEvent event) => FlutterDropzonePlatform.instance.events.add(DropzoneHoverEvent(viewId));

  void _onDrop(MouseEvent event, File data) =>
      FlutterDropzonePlatform.instance.events.add(DropzoneDropEvent(viewId, data));

  void _onLeave(MouseEvent event) => FlutterDropzonePlatform.instance.events.add(DropzoneLeaveEvent(viewId));
}

@JS('create')
external void _nativeCreate(
    dynamic container, Function onLoaded, Function onError, Function onHover, Function onDrop, Function onLeave);

@JS('setMIME')
external bool _nativeSetMIME(dynamic container, List<String> mime);

@JS('setOperation')
external bool _nativeSetOperation(dynamic container, String operation);

@JS('setCursor')
external bool _nativeSetCursor(dynamic container, String cursor);
