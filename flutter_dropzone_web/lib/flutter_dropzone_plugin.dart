import 'dart:async';
import 'dart:html' as html;
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
  static Future<bool> _isReady;

  static void registerWith(Registrar registrar) {
    final self = FlutterDropzonePlugin();
    _isReady = _readyCompleter.future;
    html.window.addEventListener('flutter_dropzone_web_ready', (_) => _readyCompleter.complete(true));
    FlutterDropzonePlatform.instance = self;

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('com.creativephotocloud.plugins/dropzone', (viewId) {
      final view = _views[viewId] = FlutterDropzoneView(viewId);
      return view.container;
    });

    final body = html.window.document.querySelector('body');
    // Hot reload would add it again
    for (html.ScriptElement script in body.querySelectorAll('script'))
      if (script.src.contains('flutter_dropzone')) {
        script.remove();
      }

    body.append(html.ScriptElement()
      ..src = 'assets/packages/flutter_dropzone_web/assets/flutter_dropzone.js'
      ..type = 'application/javascript');
  }

  @override
  void init(Map<String, dynamic> params, {@required int viewId}) {
    _views[viewId].init(params);
  }

  @override
  Future<bool> setOperation(DragOperation operation, {@required int viewId}) {
    return _views[viewId].setOperation(operation);
  }

  @override
  Future<bool> setMIME(List<String> mime, {@required int viewId}) {
    return _views[viewId].setMIME(mime);
  }

  @override
  Widget buildView(Map<String, dynamic> creationParams, Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers, PlatformViewCreatedCallback onPlatformViewCreated) => FutureBuilder<bool>(
        future: _isReady,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //TODO change to HtmlElementView when https://github.com/flutter/flutter/issues/56181 fixed
            return HtmlElementViewEx(
              viewType: 'com.creativephotocloud.plugins/dropzone',
              onPlatformViewCreated: onPlatformViewCreated,
              creationParams: creationParams,
            );
          } else if (snapshot.hasError)
            return Center(child: Text('Error loading library'));
          else
            return Center(child: CircularProgressIndicator());
        },
      );
}
