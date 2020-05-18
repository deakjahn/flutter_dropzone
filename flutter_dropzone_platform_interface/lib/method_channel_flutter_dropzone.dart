import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'flutter_dropzone_platform_interface.dart';

class MethodChannelFlutterDropzone extends FlutterDropzonePlatform {
  @override
  void init(Map<String, dynamic> params, {@required int viewId}) {
    throw UnsupportedError('DropzoneView: $defaultTargetPlatform is not supported');
  }

  @override
  Future<bool> setOperation(DragOperation operation, {@required int viewId}) {
    throw UnsupportedError('DropzoneView: $defaultTargetPlatform is not supported');
  }

  @override
  Future<bool> setMIME(List<String> mime, {@required int viewId}) async {
    throw UnsupportedError('DropzoneView: $defaultTargetPlatform is not supported');
  }

  @override
  Widget buildView(Map<String, dynamic> creationParams, Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers, PlatformViewCreatedCallback onPlatformViewCreated) {
    return Text('DropzoneView: $defaultTargetPlatform is not supported');
  }
}
