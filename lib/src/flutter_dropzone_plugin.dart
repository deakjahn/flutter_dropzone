import 'dart:async';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/src/flutter_dropzone_web.dart';
import 'package:flutter_dropzone/src/html_element_view.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

enum DragOperation { copy, move, link, copyMove, copyLink, linkMove, all }

class FlutterDropzonePlugin extends PlatformInterface {
  static final _token = Object();
  static FlutterDropzonePlugin _instance = FlutterDropzonePlugin();
  final events = StreamController<DropzoneEvent>.broadcast();
  static final _zones = <int, FlutterDropzoneView>{};
  static final _readyCompleter = Completer<bool>();
  static Future<bool> _isReady;

  FlutterDropzonePlugin() : super(token: _token);

  /// The default instance of [FlutterDropzonePlugin] to use.
  static FlutterDropzonePlugin get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [FlutterDropzonePlugin] when they register themselves.
  static set instance(FlutterDropzonePlugin instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  static void registerWith(Registrar registrar) {
    _isReady = _readyCompleter.future;
    html.window.addEventListener('flutter_dropzone_web_ready', (_) => _readyCompleter.complete(true));

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('com.creativephotocloud.plugins/dropzone', (viewId) {
      final view = _zones[viewId] = FlutterDropzoneView(viewId);
      return view.container;
    });

    final body = html.window.document.querySelector('body');
    // Hot reload would add it again
    for (html.ScriptElement script in body.querySelectorAll('script'))
      if (script.src.contains('flutter_dropzone')) {
        script.remove();
      }

    body.append(html.ScriptElement()
      ..src = 'assets/packages/flutter_dropzone/assets/flutter_dropzone.js'
      ..type = 'application/javascript');
  }

  void init(Map<String, dynamic> params, {@required int viewId}) {
    _zones[viewId].init(params);
  }

  Future<bool> setOperation(DragOperation operation, {@required int viewId}) async {
    return _zones[viewId].setOperation(operation);
  }

  Future<bool> setMIME(List<String> mime, {@required int viewId}) async {
    return _zones[viewId].setMIME(mime);
  }

  Stream<DropzoneLoadedEvent> onLoaded({@required int viewId}) {
    return events.stream //
        .where((event) => event.viewId == viewId && event is DropzoneLoadedEvent)
        .cast<DropzoneLoadedEvent>();
  }

  Stream<DropzoneErrorEvent> onError({@required int viewId}) {
    return events.stream //
        .where((event) => event.viewId == viewId && event is DropzoneErrorEvent)
        .cast<DropzoneErrorEvent>();
  }

  Stream<DropzoneDropEvent> onDrop({@required int viewId}) {
    return events.stream //
        .where((event) => event.viewId == viewId && event is DropzoneDropEvent)
        .cast<DropzoneDropEvent>();
  }

  Widget buildView(Map<String, dynamic> creationParams, Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers, PlatformViewCreatedCallback onPlatformViewCreated) => FutureBuilder<bool>(
        future: _isReady,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('buildView');
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

class DropzoneEvent<T> {
  final int viewId;
  final html.MouseEvent mouse;
  final T value;

  DropzoneEvent(this.viewId, this.mouse, [this.value]);
}

class DropzoneLoadedEvent extends DropzoneEvent {
  DropzoneLoadedEvent(int viewId) : super(viewId, null);
}

class DropzoneErrorEvent extends DropzoneEvent<String> {
  DropzoneErrorEvent(int viewId, String error) : super(viewId, null, error);
}

class DropzoneDropEvent extends DropzoneEvent<String> {
  DropzoneDropEvent(int viewId, html.MouseEvent mouse, String file) : super(viewId, mouse, file);
}
