import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone_platform_interface/flutter_dropzone_platform_interface.dart';
import 'package:flutter_dropzone_web/flutter_dropzone_web.dart';
import 'package:flutter_dropzone_web/html_element_view.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class FlutterDropzonePlugin extends FlutterDropzonePlatform {
  static final _views = <int, FlutterDropzoneView>{};
  static final _readyCompleter = Completer<bool>();
  static late final Future<bool> _isReady;

  static void registerWith(Registrar registrar) {
    final self = FlutterDropzonePlugin();
    _isReady = _readyCompleter.future;
    html.window.addEventListener('flutter_dropzone_web_ready', (_) {
      if (!_readyCompleter.isCompleted) _readyCompleter.complete(true);
    });
    FlutterDropzonePlatform.instance = self;

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('com.creativephotocloud.plugins/dropzone', (viewId) {
      final view = _views[viewId] = FlutterDropzoneView(viewId);
      return view.container;
    });

    html.document.body!.append(html.ScriptElement()
      ..src = 'assets/packages/flutter_dropzone_web/assets/flutter_dropzone.js' // ignore: unsafe_html
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
  Future<List<dynamic>> pickFiles(bool multiple, {required int viewId}) {
    return _views[viewId]!.pickFiles(multiple);
  }

  @override
  Future<String> getFilename(dynamic htmlFile, {required int viewId}) {
    return _views[viewId]!.getFilename(htmlFile);
  }

  @override
  Future<int> getFileSize(dynamic htmlFile, {required int viewId}) {
    return _views[viewId]!.getFileSize(htmlFile);
  }

  @override
  Future<String> getFileMIME(dynamic htmlFile, {required int viewId}) {
    return _views[viewId]!.getFileMIME(htmlFile);
  }

  @override
  Future<String> createFileUrl(dynamic htmlFile, {required int viewId}) {
    return _views[viewId]!.createFileUrl(htmlFile);
  }

  @override
  Future<bool> releaseFileUrl(String fileUrl, {required int viewId}) {
    return _views[viewId]!.releaseFileUrl(fileUrl);
  }

  @override
  Future<Uint8List> getFileData(dynamic htmlFile, {required int viewId}) {
    return _views[viewId]!.getFileData(htmlFile);
  }

  @override
  Widget buildView(Map<String, dynamic> creationParams, Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers, PlatformViewCreatedCallback onPlatformViewCreated) => FutureBuilder<bool>(
        future: _isReady,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HtmlElementViewEx(
              viewType: 'com.creativephotocloud.plugins/dropzone',
              onPlatformViewCreated: onPlatformViewCreated,
            );
          } else if (snapshot.hasError)
            return Center(child: Text('Error loading library'));
          else
            return Center(child: CircularProgressIndicator());
        },
      );
}
