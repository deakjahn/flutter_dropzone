import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dropzone_platform_interface/dropzone_file.dart';

import 'flutter_dropzone_platform_interface.dart';

class MethodChannelFlutterDropzone extends FlutterDropzonePlatform {
  @override
  void init(Map<String, dynamic> params, {required int viewId}) {
    throw UnsupportedError(
        'DropzoneView: $defaultTargetPlatform is not supported');
  }

  @override
  Future<bool> setOperation(DragOperation operation, {required int viewId}) {
    throw UnsupportedError(
        'DropzoneView: $defaultTargetPlatform is not supported');
  }

  @override
  Future<bool> setCursor(CursorType cursor, {required int viewId}) {
    throw UnsupportedError(
        'DropzoneView: $defaultTargetPlatform is not supported');
  }

  @override
  Future<bool> setMIME(List<String> mime, {required int viewId}) {
    throw UnsupportedError(
        'DropzoneView: $defaultTargetPlatform is not supported');
  }

  @override
  Future<List<DropzoneFile>> pickFiles(bool multiple,
      {List<String> mime = const [], required int viewId}) {
    throw UnsupportedError(
        'DropzoneView: $defaultTargetPlatform is not supported');
  }

  @override
  Future<String> getFilename(DropzoneFile htmlFile, {required int viewId}) async {
    throw UnsupportedError(
        'DropzoneView: $defaultTargetPlatform is not supported');
  }

  @override
  Future<int> getFileSize(DropzoneFile htmlFile, {required int viewId}) async {
    throw UnsupportedError(
        'DropzoneView: $defaultTargetPlatform is not supported');
  }

  @override
  Future<String> getFileMIME(DropzoneFile htmlFile, {required int viewId}) async {
    throw UnsupportedError(
        'DropzoneView: $defaultTargetPlatform is not supported');
  }

  @override
  Future<DateTime> getFileLastModified(DropzoneFile htmlFile,
      {required int viewId}) async {
    throw UnsupportedError(
        'DropzoneView: $defaultTargetPlatform is not supported');
  }

  @override
  Future<String> createFileUrl(DropzoneFile htmlFile, {required int viewId}) async {
    throw UnsupportedError(
        'DropzoneView: $defaultTargetPlatform is not supported');
  }

  @override
  Future<bool> releaseFileUrl(String fileUrl, {required int viewId}) async {
    throw UnsupportedError(
        'DropzoneView: $defaultTargetPlatform is not supported');
  }

  @override
  Future<Uint8List> getFileData(DropzoneFile htmlFile, {required int viewId}) async {
    throw UnsupportedError(
        'DropzoneView: $defaultTargetPlatform is not supported');
  }

  @override
  Stream<List<int>> getFileStream(DropzoneFile htmlFile,
      {required int viewId}) async* {
    throw UnsupportedError(
        'DropzoneView: $defaultTargetPlatform is not supported');
  }

  @override
  Widget buildView(
      Map<String, dynamic> creationParams,
      Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
      PlatformViewCreatedCallback onPlatformViewCreated) {
    return Text('DropzoneView: $defaultTargetPlatform is not supported');
  }
}