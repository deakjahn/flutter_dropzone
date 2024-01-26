@JS('flutter_dropzone_web')
library flutter_dropzone_web;

import 'dart:async';
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter_dropzone_platform_interface/flutter_dropzone_platform_interface.dart';
import 'package:js/js.dart';

class FlutterDropzoneView {
  final int viewId;
  late final DivElement container;
  List<String>? mime;
  DragOperation? operation;
  CursorType? cursor;

  FlutterDropzoneView(this.viewId) {
    final id = 'dropzone-container-$viewId';
    container = DivElement()
      ..id = id
      ..style.pointerEvents = 'auto'
      ..style.border = 'none'
      // idea from https://keithclark.co.uk/articles/working-with-elements-before-the-dom-is-ready/
      ..append(StyleElement()
        ..innerText =
            '@keyframes $id-animation {from { clip: rect(1px, auto, auto, auto); } to { clip: rect(0px, auto, auto, auto); }}')
      ..style.animationName = '$id-animation'
      ..style.animationDuration = '0.001s'
      ..style.width = '100%'
      ..style.height = '100%'
      ..addEventListener('animationstart', (event) {
        _nativeCreate(
          container,
          allowInterop(_onLoaded),
          allowInterop(_onError),
          allowInterop(_onHover),
          allowInterop(_onDrop),
          allowInterop(_onDropInvalid),
          allowInterop(_onDropMultiple),
          allowInterop(_onLeave),
        );
        if (mime != null) setMIME(mime!);
        if (operation != null) setOperation(operation!);
        if (cursor != null) setCursor(cursor!);
      });
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
    return _nativeSetCursor(
        container, describeEnum(cursor).toLowerCase().replaceAll('_', '-'));
  }

  Future<List<dynamic>> pickFiles(bool multiple, List<String> mime) {
    final completer = Completer<List<dynamic>>();
    final picker = FileUploadInputElement();
    final isSafari =
        window.navigator.userAgent.toLowerCase().contains('safari');
    if (isSafari) document.body!.append(picker);
    picker.multiple = multiple;
    if (mime.isNotEmpty) picker.accept = mime.join(',');
    picker.onChange.listen((_) {
      completer.complete(picker.files);
      if (isSafari) picker.remove();
    });
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

  Future<DateTime> getFileLastModified(File file) async {
    return file.lastModified != null
        ? DateTime.fromMillisecondsSinceEpoch(file.lastModified!)
        : file.lastModifiedDate;
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
    reader.onLoad.listen((_) => completer.complete(reader.result as Uint8List));
    return completer.future;
  }

  Stream<List<int>> getFileStream(File file) async* {
    const int chunkSize = 1024 * 1024;
    final reader = FileReader();
    int start = 0;
    while (start < file.size) {
      final end = start + chunkSize > file.size ? file.size : start + chunkSize;
      final blob = file.slice(start, end);
      reader.readAsArrayBuffer(blob);
      await reader.onLoad.first;
      yield reader.result as List<int>;
      start += chunkSize;
    }
  }

  void _onLoaded() =>
      FlutterDropzonePlatform.instance.events.add(DropzoneLoadedEvent(viewId));

  void _onError(String error) => FlutterDropzonePlatform.instance.events
      .add(DropzoneErrorEvent(viewId, error));

  void _onHover(MouseEvent event) =>
      FlutterDropzonePlatform.instance.events.add(DropzoneHoverEvent(viewId));

  void _onDrop(MouseEvent event, dynamic data) =>
      FlutterDropzonePlatform.instance.events
          .add(DropzoneDropEvent(viewId, data));

  void _onDropInvalid(MouseEvent event, String mime) =>
      FlutterDropzonePlatform.instance.events
          .add(DropzoneDropInvalidEvent(viewId, mime));

  void _onDropMultiple(MouseEvent event, List<dynamic> data) =>
      FlutterDropzonePlatform.instance.events
          .add(DropzoneDropMultipleEvent(viewId, data));

  void _onLeave(MouseEvent event) =>
      FlutterDropzonePlatform.instance.events.add(DropzoneLeaveEvent(viewId));
}

@JS('create')
external void _nativeCreate(
    dynamic container,
    Function onLoaded,
    Function onError,
    Function onHover,
    Function onDrop,
    Function onDropInvalid,
    Function onDropMultiple,
    Function onLeave);

@JS('setMIME')
external bool _nativeSetMIME(dynamic container, List<String> mime);

@JS('setOperation')
external bool _nativeSetOperation(dynamic container, String operation);

@JS('setCursor')
external bool _nativeSetCursor(dynamic container, String cursor);
