import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// https://github.com/flutter/flutter/issues/56181

class HtmlElementViewEx extends HtmlElementView {
  final PlatformViewCreatedCallback onPlatformViewCreated; //!!!
  final dynamic creationParams;

  const HtmlElementViewEx({Key? key, required String viewType, required this.onPlatformViewCreated, this.creationParams}) : super(key: key, viewType: viewType);

  @override
  Widget build(BuildContext context) => PlatformViewLink(
        viewType: viewType,
        onCreatePlatformView: _createHtmlElementView,
        surfaceFactory: (BuildContext context, PlatformViewController controller) => PlatformViewSurface(
          controller: controller,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        ),
      );

  _HtmlElementViewControllerEx _createHtmlElementView(PlatformViewCreationParams params) {
    final _HtmlElementViewControllerEx controller = _HtmlElementViewControllerEx(params.id, viewType);
    controller._initialize().then((_) {
      params.onPlatformViewCreated(params.id);
      onPlatformViewCreated(params.id); //!!!
    });
    return controller;
  }
}

class _HtmlElementViewControllerEx extends PlatformViewController {
  @override
  final int viewId;
  final String viewType;
  bool _initialized = false;

  _HtmlElementViewControllerEx(this.viewId, this.viewType);

  Future<void> _initialize() async {
    await SystemChannels.platform_views.invokeMethod<void>('create', {'id': viewId, 'viewType': viewType});
    _initialized = true;
  }

  @override
  Future<void> clearFocus() async {}

  @override
  Future<void> dispatchPointerEvent(PointerEvent event) async {}

  @override
  Future<void> dispose() async {
    if (_initialized) await SystemChannels.platform_views.invokeMethod<void>('dispose', viewId);
  }
}
