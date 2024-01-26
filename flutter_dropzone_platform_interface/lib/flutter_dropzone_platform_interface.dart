import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_flutter_dropzone.dart';

enum DragOperation { copy, move, link, copyMove, copyLink, linkMove, all }

enum CursorType {
  alias,
  all_scroll,
  auto,
  cell,
  context_menu,
  col_resize,
  copy,
  crosshair,
  Default,
  e_resize,
  ew_resize,
  grab,
  grabbing,
  help,
  move,
  n_resize,
  ne_resize,
  nesw_resize,
  ns_resize,
  nw_resize,
  nwse_resize,
  no_drop,
  none,
  not_allowed,
  pointer,
  progress,
  row_resize,
  s_resize,
  se_resize,
  sw_resize,
  text,
  w_resize,
  wait,
  zoom_in,
  zoom_out
}

abstract class FlutterDropzonePlatform extends PlatformInterface {
  static final _token = Object();
  final events = StreamController<DropzoneEvent>.broadcast();
  static FlutterDropzonePlatform _instance = MethodChannelFlutterDropzone();

  FlutterDropzonePlatform() : super(token: _token);

  /// The default instance of [FlutterDropzonePlatform] to use.
  static FlutterDropzonePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [FlutterDropzonePlatform] when they register themselves.
  static set instance(FlutterDropzonePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Internal function to set up the platform view.
  void init(Map<String, dynamic> params, {required int viewId}) {
    throw UnimplementedError('init');
  }

  /// Specify the [DragOperation] while dragging the file.
  Future<bool> setOperation(DragOperation operation,
      {required int viewId}) async {
    throw UnimplementedError('setOperation');
  }

  /// Specify the [CursorType] of the dropzone. [CursorType] is one the CSS cursor types.
  Future<bool> setCursor(CursorType cursor, {required int viewId}) async {
    throw UnimplementedError('setCursor');
  }

  /// Specify the list of accepted MIME types.
  Future<bool> setMIME(List<String> mime, {required int viewId}) async {
    throw UnimplementedError('setMIME');
  }

  /// Convenience function to display the browser File Open dialog.
  ///
  /// Set [multiple] to allow picking more than one file.
  /// Specify the list of accepted MIME types in [mime].
  /// Returns the list of files picked by the user.
  Future<List<dynamic>> pickFiles(bool multiple,
      {List<String> mime = const [], required int viewId}) async {
    throw UnimplementedError('pickFiles');
  }

  /// Get the filename of the passed HTML file.
  Future<String> getFilename(dynamic htmlFile, {required int viewId}) async {
    throw UnimplementedError('getFilename');
  }

  /// Get the size of the passed HTML file.
  Future<int> getFileSize(dynamic htmlFile, {required int viewId}) async {
    throw UnimplementedError('getFileSize');
  }

  /// Get the MIME type of the passed HTML file.
  Future<String> getFileMIME(dynamic htmlFile, {required int viewId}) async {
    throw UnimplementedError('getFileMIME');
  }

  /// Get the last modified data of the passed HTML file.
  Future<DateTime> getFileLastModified(dynamic htmlFile,
      {required int viewId}) async {
    throw UnimplementedError('getFileLastModified');
  }

  /// Create a temporary URL to the passed HTML file.
  ///
  /// When finished, the URL should be released using [releaseFileUrl()].
  Future<String> createFileUrl(dynamic htmlFile, {required int viewId}) async {
    throw UnimplementedError('createFileUrl');
  }

  /// Release a temporary URL previously created using [createFileUrl()].
  Future<bool> releaseFileUrl(String fileUrl, {required int viewId}) async {
    throw UnimplementedError('releaseFileUrl');
  }

  /// Get the contents of the passed HTML file.
  Future<Uint8List> getFileData(dynamic htmlFile, {required int viewId}) async {
    throw UnimplementedError('getFileData');
  }

  /// Get the contents of the passed HTML file as a chunked stream.
  Stream<List<int>> getFileStream(dynamic htmlFile,
      {required int viewId}) async* {
    throw UnimplementedError('getFileStream');
  }

  /// Event called when the dropzone view has been loaded.
  Stream<DropzoneLoadedEvent> onLoaded({required int viewId}) {
    return events.stream //
        .where(
            (event) => event.viewId == viewId && event is DropzoneLoadedEvent)
        .cast<DropzoneLoadedEvent>();
  }

  /// Event called if the dropzone view has an error.
  Stream<DropzoneErrorEvent> onError({required int viewId}) {
    return events.stream //
        .where((event) => event.viewId == viewId && event is DropzoneErrorEvent)
        .cast<DropzoneErrorEvent>();
  }

  /// Event called when the user hovers over a dropzone.
  Stream<DropzoneHoverEvent> onHover({required int viewId}) {
    return events.stream //
        .where((event) => event.viewId == viewId && event is DropzoneHoverEvent)
        .cast<DropzoneHoverEvent>();
  }

  /// Event called when the user drops a file onto the dropzone.
  Stream<DropzoneDropEvent> onDrop({required int viewId}) {
    return events.stream //
        .where((event) => event.viewId == viewId && event is DropzoneDropEvent)
        .cast<DropzoneDropEvent>();
  }

  /// Event called when the user tries to drop an invalid file onto the dropzone.
  Stream<DropzoneDropInvalidEvent> onDropInvalid({required int viewId}) {
    return events.stream //
        .where((event) =>
            event.viewId == viewId && event is DropzoneDropInvalidEvent)
        .cast<DropzoneDropInvalidEvent>();
  }

  /// Event called when the user drops multiple files onto the dropzone.
  Stream<DropzoneDropMultipleEvent> onDropMultiple({required int viewId}) {
    return events.stream //
        .where((event) =>
            event.viewId == viewId && event is DropzoneDropMultipleEvent)
        .cast<DropzoneDropMultipleEvent>();
  }

  /// Event called when the user leaves a dropzone.
  Stream<DropzoneLeaveEvent> onLeave({required int viewId}) {
    return events.stream //
        .where((event) => event.viewId == viewId && event is DropzoneLeaveEvent)
        .cast<DropzoneLeaveEvent>();
  }

  /// Internal function to build the platform view.
  Widget buildView(
      Map<String, dynamic> creationParams,
      Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
      PlatformViewCreatedCallback onPlatformViewCreated) {
    throw UnimplementedError('buildView');
  }

  void dispose() {
    events.close();
  }
}

class DropzoneEvent<T> {
  final int viewId;
  final T? value;

  DropzoneEvent(this.viewId, [this.value]);
}

/// Event called when the dropzone view has been loaded.
class DropzoneLoadedEvent extends DropzoneEvent {
  DropzoneLoadedEvent(int viewId) : super(viewId, null);
}

/// Event called if the dropzone view has an error.
class DropzoneErrorEvent extends DropzoneEvent<String> {
  DropzoneErrorEvent(int viewId, String error) : super(viewId, error);
}

/// Event called when the user hovers over a dropzone.
class DropzoneHoverEvent extends DropzoneEvent {
  DropzoneHoverEvent(int viewId) : super(viewId, null);
}

/// Event called when the user drops a file onto the dropzone.
class DropzoneDropEvent extends DropzoneEvent<dynamic> {
  DropzoneDropEvent(int viewId, dynamic file) : super(viewId, file);
}

/// Event called when the user tries to drop an invalid file onto the dropzone.
class DropzoneDropInvalidEvent extends DropzoneEvent<dynamic> {
  DropzoneDropInvalidEvent(int viewId, String mime) : super(viewId, mime);
}

/// Event called when the user drops multiple files onto the dropzone.
class DropzoneDropMultipleEvent extends DropzoneEvent<List<dynamic>> {
  DropzoneDropMultipleEvent(int viewId, List<dynamic> files)
      : super(viewId, files);
}

/// Event called when the user leaves a dropzone.
class DropzoneLeaveEvent extends DropzoneEvent {
  DropzoneLeaveEvent(int viewId) : super(viewId, null);
}
