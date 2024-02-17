@JS('flutter_dropzone_web')
library flutter_dropzone_web;

import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter_dropzone_platform_interface/flutter_dropzone_platform_interface.dart';
import 'package:js/js.dart' as js;
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
      js.allowInterop(_onLoaded),
      js.allowInterop(_onError),
      js.allowInterop(_onHover),
      js.allowInterop(_onDrop),
      js.allowInterop(_onDropInvalid),
      js.allowInterop(_onDropMultiple),
      js.allowInterop(_onLeave),
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

  Future<bool> setMIME(List<String> mime) async {
    return setMimeJS(container, mime);
  }

  Future<bool> setOperation(DragOperation operation) async {
    return setOperationJS(container, operation.name);
  }

  Future<bool> setCursor(CursorType cursor) async {
    return setCursorJS(
        container, cursor.name.toLowerCase().replaceAll('_', '-'));
  }

  Future<List<dynamic>> pickFiles(bool multiple, List<String> mime) {
    final completer = Completer<List<dynamic>>();
    final picker = web.HTMLInputElement();
    final isSafari =
        web.window.navigator.userAgent.toLowerCase().contains('safari');
    if (isSafari) web.document.body!.append(picker);
    picker.multiple = multiple;
    if (mime.isNotEmpty) picker.accept = mime.join(',');

    void onChangeHandler() {
      if (picker.files != null) {
        final list = List.generate(
            picker.files!.length, (index) => picker.files!.item(index));
        completer.complete(list);
      }
      else
        completer.complete([]);
      if (isSafari) picker.remove();
    }

    void onCancelHandler() {
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
    return createObjectUrlJS(file);
  }

  Future<bool> releaseFileUrl(String fileUrl) async {
    revokeObjectUrlJS(fileUrl);
    return true;
  }

  Future<Uint8List> getFileData(web.File file) async {
    return file.arrayBuffer() as Uint8List;
    // final completer = Completer<Uint8List>();
    // final reader = web.FileReader();
    // reader.readAsArrayBuffer(file);
    // reader.onload = (_) {
    //   completer.complete(reader.result as Uint8List);
    // }.toJS;
    // return completer.future;
  }

  Stream<List<int>> getFileStream(web.File file) async* {
    // final reader = file.stream().getReader();
    const int chunkSize = 1024 * 1024;
    final reader = web.FileReader();
    int start = 0;
    while (start < file.size) {
      final end = start + chunkSize > file.size ? file.size : start + chunkSize;
      final blob = file.slice(start, end);
      reader.readAsArrayBuffer(blob);
      await reader.onLoadEnd.first; //???
      yield reader.result as List<int>;
      start += chunkSize;
    }
  }

  void _onLoaded() =>
      FlutterDropzonePlatform.instance.events.add(DropzoneLoadedEvent(viewId));

  void _onError(String error) => FlutterDropzonePlatform.instance.events
      .add(DropzoneErrorEvent(viewId, error));

  void _onHover(web.MouseEvent event) =>
      FlutterDropzonePlatform.instance.events.add(DropzoneHoverEvent(viewId));

  void _onDrop(web.MouseEvent event, dynamic data) =>
      FlutterDropzonePlatform.instance.events
          .add(DropzoneDropEvent(viewId, data));

  void _onDropInvalid(web.MouseEvent event, String mime) =>
      FlutterDropzonePlatform.instance.events
          .add(DropzoneDropInvalidEvent(viewId, mime));

  void _onDropMultiple(web.MouseEvent event, List<dynamic> data) =>
      FlutterDropzonePlatform.instance.events
          .add(DropzoneDropMultipleEvent(viewId, data));

  void _onLeave(web.MouseEvent event) =>
      FlutterDropzonePlatform.instance.events.add(DropzoneLeaveEvent(viewId));
}

@JS("create")
external void createJS(
    web.HTMLDivElement container,
    Function onLoaded,
    Function onError,
    Function onHover,
    Function onDrop,
    Function onDropInvalid,
    Function onDropMultiple,
    Function onLeave);

@JS("setMIME")
external bool setMimeJS(web.HTMLDivElement container, List<String> mime);

@JS("setOperation")
external bool setOperationJS(web.HTMLDivElement container, String operation);

@JS("setCursor")
external bool setCursorJS(web.HTMLDivElement container, String cursor);

@JS("createObjectUrl")
external String createObjectUrlJS(web.Blob object);

@JS("revokeObjectUrl")
external void revokeObjectUrlJS(String url);
