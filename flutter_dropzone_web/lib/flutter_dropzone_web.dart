@JS('flutter_dropzone_web')
library flutter_dropzone_web;

import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter_dropzone_platform_interface/flutter_dropzone_platform_interface.dart';
// ignore: unused_import
import 'file/dropzone_file_stub.dart'
    if (dart.library.js_interop) 'file/dropzone_file_web.dart'
    if (dart.library.io) 'file/dropzone_file_dummy.dart';
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
      _onDropFile.toJS,
      _onDropString.toJS,
      _onDropInvalid.toJS,
      _onDropMultiple.toJS,
      _onDropFiles.toJS,
      _onDropStrings.toJS,
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

  Future<List<DropzoneFileInterface>> pickFiles(
      bool multiple, List<String> mime) {
    final completer = Completer<List<DropzoneFileInterface>>();
    final picker = web.HTMLInputElement();
    final isSafari =
        web.window.navigator.userAgent.toLowerCase().contains('safari');
    picker.type = 'file';
    if (isSafari) web.document.body!.append(picker);
    picker.multiple = multiple;
    if (mime.isNotEmpty) picker.accept = mime.join(',');

    void onChangeHandler(web.Event evt) {
      if (picker.files != null) {
        final list = List.generate(picker.files!.length,
            (index) => createFile(picker.files!.item(index)!));
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

  Future<String> getFilename(DropzoneFileInterface file) async {
    return file.name;
  }

  Future<int> getFileSize(DropzoneFileInterface file) async {
    return file.size;
  }

  Future<String> getFileMIME(DropzoneFileInterface file) async {
    return file.type;
  }

  Future<DateTime> getFileLastModified(DropzoneFileInterface file) async {
    return DateTime.fromMillisecondsSinceEpoch(file.lastModified);
  }

  Future<String> createFileUrl(DropzoneFileInterface file) async {
    final webFile = file.getNative() as web.File;
    return web.URL.createObjectURL(webFile);
  }

  Future<bool> releaseFileUrl(String fileUrl) async {
    web.URL.revokeObjectURL(fileUrl);
    return true;
  }

  Future<Uint8List> getFileData(DropzoneFileInterface file) async {
    final webFile = file.getNative() as web.File;
    final arrayBuffer = await webFile.arrayBuffer().toDart;
    return arrayBuffer.toDart.asUint8List();
  }

  Stream<List<int>> getFileStream(DropzoneFileInterface file) async* {
    const int chunkSize = 1024 * 1024;
    int start = 0;
    while (start < file.size) {
      final end = start + chunkSize > file.size
          ? file.size
          : start + chunkSize;
      final webFile = file.getNative() as web.File;
      final blob = webFile.slice(start, end);
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

  void _onDropFile(web.MouseEvent event, web.File file) =>
      FlutterDropzonePlatform.instance.events
          .add(DropzoneDropFileEvent(viewId, createFile(file)));

  void _onDropString(web.MouseEvent event, JSString string) =>
      FlutterDropzonePlatform.instance.events
          .add(DropzoneDropStringEvent(viewId, string.toDart));

  void _onDropInvalid(web.MouseEvent event, JSString mime) =>
      FlutterDropzonePlatform.instance.events
          .add(DropzoneDropInvalidEvent(viewId, mime.toDart));

  void _onDropMultiple(web.MouseEvent event, JSArray<web.File> data) =>
      FlutterDropzonePlatform.instance.events
          .add(DropzoneDropMultipleEvent(viewId, data.toDart));

  void _onDropFiles(web.MouseEvent event, JSArray<web.File> files) =>
      FlutterDropzonePlatform.instance.events.add(DropzoneDropFilesEvent(
          viewId, files.toDart.map((file) => createFile(file)).toList()));

  void _onDropStrings(web.MouseEvent event, JSArray<JSString> strings) =>
      FlutterDropzonePlatform.instance.events.add(DropzoneDropStringsEvent(
          viewId, strings.toDart.map((string) => string.toDart).toList()));

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
    JSFunction onDropFile,
    JSFunction onDropString,
    JSFunction onDropInvalid,
    JSFunction onDropMultiple,
    JSFunction onDropFiles,
    JSFunction onDropStrings,
    JSFunction onLeave);

@JS('setMIME')
external bool setMimeJS(web.HTMLDivElement container, JSArray<JSString> mime);

@JS('setOperation')
external bool setOperationJS(web.HTMLDivElement container, JSString operation);

@JS('setCursor')
external bool setCursorJS(web.HTMLDivElement container, JSString cursor);