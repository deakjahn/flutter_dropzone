@JS('flutter_dropzone_web')
library flutter_dropzone_web;

import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter_dropzone_platform_interface/flutter_dropzone_platform_interface.dart';
import 'package:web/web.dart' as web;

class FlutterDropzoneView {
  final int viewId;
  late final web.HTMLDivElement container;
  List<String>? mime;
  DragOperation? operation;
  CursorType? cursor;

  FlutterDropzoneView(this.viewId) {
    final id = 'dropzone-container-$viewId';
    container = web.HTMLDivElement()
      ..id = id
      ..style.pointerEvents = 'auto'
      ..style.border = 'none'
      // idea from https://keithclark.co.uk/articles/working-with-elements-before-the-dom-is-ready/
      ..append(web.HTMLStyleElement()
        ..innerText =
            '@keyframes $id-animation {from { clip: rect(1px, auto, auto, auto); } to { clip: rect(0px, auto, auto, auto); }}')
      ..style.animationName = '$id-animation'
      ..style.animationDuration = '0.001s'
      ..style.width = '100%'
      ..style.height = '100%'
      ..addEventListener('animationstart', _startCallback.toJS);
  }

  void _startCallback(web.Event event) {
    createJS(
      container,
      _onLoaded.toJS,
      _onError.toJS,
      _onHover.toJS,
      _onDrop.toJS,
      _onDropInvalid.toJS,
      _onDropMultiple.toJS,
      _onLeave.toJS,
    );
    if (mime != null) setMIME(mime!);
    if (operation != null) setOperation(operation!);
    if (cursor != null) setCursor(cursor!);
  }

  void init(Map<String, dynamic> params) {
    mime = params['mime'];
    operation = params['operation'];
    cursor = params['cursor'];
  }

  Future<bool> setMIME(List<String> mimes) async {
    return setMimeJS(container, [for (final mime in mimes) mime.toJS].toJS);
  }

  Future<bool> setOperation(DragOperation operation) async {
    return setOperationJS(container, operation.name.toJS);
  }

  Future<bool> setCursor(CursorType cursor) async {
    return setCursorJS(
        container, cursor.name.toLowerCase().replaceAll('_', '-').toJS);
  }

  Future<List<dynamic>> pickFiles(bool multiple, List<String> mime) {
    final completer = Completer<List<dynamic>>();
    final picker = web.HTMLInputElement();
    final isSafari =
        web.window.navigator.userAgent.toLowerCase().contains('safari');
    picker.type = 'file';
    if (isSafari) web.document.body!.append(picker);
    picker.multiple = multiple;
    if (mime.isNotEmpty) picker.accept = mime.join(',');

    void onChangeHandler(web.Event evt) {
      if (picker.files != null) {
        final list = List.generate(
            picker.files!.length, (index) => picker.files!.item(index));
        completer.complete(list);
      } else
        completer.complete([]);
      if (isSafari) picker.remove();
    }

    void onCancelHandler(web.Event evt) {
      completer.complete([]);
      if (isSafari) picker.remove();
    }

    picker.onchange = onChangeHandler.toJS;
    picker.oncancel = onCancelHandler.toJS;
    picker.click();
    return completer.future;
  }

  Future<String> getFilename(web.File file) async {
    return file.name;
  }

  Future<int> getFileSize(web.File file) async {
    return file.size;
  }

  Future<String> getFileMIME(web.File file) async {
    return file.type;
  }

  Future<DateTime> getFileLastModified(web.File file) async {
    return DateTime.fromMillisecondsSinceEpoch(file.lastModified);
  }

  Future<String> createFileUrl(web.File file) async {
    return web.URL.createObjectURL(file);
  }

  Future<bool> releaseFileUrl(String fileUrl) async {
    web.URL.revokeObjectURL(fileUrl);
    return true;
  }

  Future<Uint8List> getFileData(web.File file) async {
    final arrayBuffer = await file.arrayBuffer().toDart;
    return arrayBuffer.toDart.asUint8List();
  }

  Stream<List<int>> getFileStream(web.File file) async* {
    const int chunkSize = 1024 * 1024;
    int start = 0;
    while (start < file.size) {
      final end = start + chunkSize > file.size ? file.size : start + chunkSize;
      final blob = file.slice(start, end);
      final arrayBuffer = await blob.arrayBuffer().toDart;
      yield arrayBuffer.toDart.asUint8List();
      start += chunkSize;
    }
  }

  void _onLoaded() =>
      FlutterDropzonePlatform.instance.events.add(DropzoneLoadedEvent(viewId));

  void _onError(String error) => FlutterDropzonePlatform.instance.events
      .add(DropzoneErrorEvent(viewId, error));

  void _onHover(web.MouseEvent event) =>
      FlutterDropzonePlatform.instance.events.add(DropzoneHoverEvent(viewId));

  void _onDrop(web.MouseEvent event, web.File data) =>
      FlutterDropzonePlatform.instance.events
          .add(DropzoneDropEvent(viewId, data));

  void _onDropInvalid(web.MouseEvent event, JSString mime) =>
      FlutterDropzonePlatform.instance.events
          .add(DropzoneDropInvalidEvent(viewId, mime.toDart));

  void _onDropMultiple(web.MouseEvent event, JSArray<web.File> data) =>
      FlutterDropzonePlatform.instance.events
          .add(DropzoneDropMultipleEvent(viewId, data.toDart));

  void _onLeave(web.MouseEvent event) =>
      FlutterDropzonePlatform.instance.events.add(DropzoneLeaveEvent(viewId));
}

@JS('create')
external void createJS(
    web.HTMLDivElement container,
    JSFunction onLoaded,
    JSFunction onError,
    JSFunction onHover,
    JSFunction onDrop,
    JSFunction onDropInvalid,
    JSFunction onDropMultiple,
    JSFunction onLeave);

@JS('setMIME')
external bool setMimeJS(web.HTMLDivElement container, JSArray<JSString> mime);

@JS('setOperation')
external bool setOperationJS(web.HTMLDivElement container, JSString operation);

@JS('setCursor')
external bool setCursorJS(web.HTMLDivElement container, JSString cursor);