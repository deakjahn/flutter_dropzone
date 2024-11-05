import 'dart:async';
import 'dart:ui_web' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone_platform_interface/flutter_dropzone_platform_interface.dart';
import 'package:flutter_dropzone_web/flutter_dropzone_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

const web.EventStreamProvider<web.Event> _flutterDropzoneWebReadyEvent =
    web.EventStreamProvider<web.Event>('flutter_dropzone_web_ready');

class FlutterDropzonePlugin extends FlutterDropzonePlatform {
  static final _views = <int, FlutterDropzoneView>{};
  static final _readyCompleter = Completer<bool>();
  static late final Future<bool> _isReady;

  static void registerWith(Registrar registrar) {
    FlutterDropzonePlatform.instance = FlutterDropzonePlugin();
    _isReady = _readyCompleter.future;

    void readyHandler() {
      if (!_readyCompleter.isCompleted) _readyCompleter.complete(true);
    }

    _flutterDropzoneWebReadyEvent.forTarget(web.window).listen((event) {
      readyHandler();
    });

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
        'io.flutter.plugins.flutter_dropzone/dropzone', (viewId) {
      final view = _views[viewId] = FlutterDropzoneView(viewId);
      return view.container;
    });
    // ignore: undefined_prefixed_name
    final scriptUrl = ui.assetManager.getAssetUrl(
      'packages/flutter_dropzone_web/assets/flutter_dropzone.js',
    );

    web.document.body!.append(web.HTMLScriptElement()
      ..src = scriptUrl
      ..type = 'application/javascript'
      ..defer = true);
  }

  @override
  void init(Map<String, dynamic> params, {required int viewId}) {
    _views[viewId]!.init(params);
  }

  @override
  Future<bool> setOperation(DragOperation operation, {required int viewId}) {
    return _views[viewId]!.setOperation(operation);
  }

  @override
  Future<bool> setCursor(CursorType cursor, {required int viewId}) {
    return _views[viewId]!.setCursor(cursor);
  }

  @override
  Future<bool> setMIME(List<String> mime, {required int viewId}) {
    return _views[viewId]!.setMIME(mime);
  }

  @override
  Future<List<DropzoneFileInterface>> pickFiles(bool multiple,
      {List<String> mime = const [], required int viewId}) {
    return _views[viewId]!.pickFiles(multiple, mime);
  }

  @override
  Future<String> getFilename(DropzoneFileInterface file,
      {required int viewId}) {
    return _views[viewId]!.getFilename(file);
  }

  @override
  Future<int> getFileSize(DropzoneFileInterface file, {required int viewId}) {
    return _views[viewId]!.getFileSize(file);
  }

  @override
  Future<String> getFileMIME(DropzoneFileInterface file,
      {required int viewId}) {
    return _views[viewId]!.getFileMIME(file);
  }

  @override
  Future<DateTime> getFileLastModified(DropzoneFileInterface file,
      {required int viewId}) {
    return _views[viewId]!.getFileLastModified(file);
  }

  @override
  Future<String> createFileUrl(DropzoneFileInterface file,
      {required int viewId}) {
    return _views[viewId]!.createFileUrl(file);
  }

  @override
  Future<bool> releaseFileUrl(String fileUrl, {required int viewId}) {
    return _views[viewId]!.releaseFileUrl(fileUrl);
  }

  @override
  Future<Uint8List> getFileData(DropzoneFileInterface file,
      {required int viewId}) {
    return _views[viewId]!.getFileData(file);
  }

  @override
  Stream<List<int>> getFileStream(DropzoneFileInterface file,
      {required int viewId}) {
    return _views[viewId]!.getFileStream(file);
  }

  @override
  Widget buildView(
          Map<String, dynamic> creationParams,
          Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
          PlatformViewCreatedCallback onPlatformViewCreated) =>
      FutureBuilder<bool>(
        future: _isReady,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HtmlElementView(
              viewType: 'io.flutter.plugins.flutter_dropzone/dropzone',
              onPlatformViewCreated: onPlatformViewCreated,
            );
          } else if (snapshot.hasError)
            return const Center(child: Text('Error loading library'));
          else
            return const Center(child: CircularProgressIndicator());
        },
      );
}
