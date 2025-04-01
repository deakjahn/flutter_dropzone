import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone_platform_interface/flutter_dropzone_platform_interface.dart';

typedef DropzoneViewCreatedCallback = void Function(DropzoneViewController controller);

// https://developer.mozilla.org/en-US/docs/Web/API/HTML_Drag_and_Drop_API
// https://developer.mozilla.org/en-US/docs/Web/API/HTML_Drag_and_Drop_API/File_drag_and_drop

class DropzoneView extends StatefulWidget {
  final DragOperation? operation;
  final CursorType? cursor;
  final List<String>? mime;
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;
  final DropzoneViewCreatedCallback? onCreated;

  /// Event called when the dropzone view has been loaded.
  final VoidCallback? onLoaded;

  /// Event called if the dropzone view has an error.
  final ValueChanged<String?>? onError;

  /// Event called when the dropzone view is hovered during a drag-drop.
  final VoidCallback? onHover;

  /// Event called when the user drops a file onto the dropzone.
  @Deprecated('Use onDropFile or onDropString instead.')
  final ValueChanged<dynamic>? onDrop;

  /// Event called when the user drops a file onto the dropzone.
  final ValueChanged<DropzoneFileInterface>? onDropFile;

  /// Event called when the user drops a string onto the dropzone.
  final ValueChanged<String>? onDropString;

  /// Event called when the user tries to drop an invalid file onto the dropzone.
  final ValueChanged<String?>? onDropInvalid;

  /// Event called when the user drops multiple files onto the dropzone.
  @Deprecated('Use onDropFiles or onDropStrings instead.')
  final ValueChanged<List<dynamic>?>? onDropMultiple;

  /// Event called when the user drops multiple files onto the dropzone.
  final ValueChanged<List<DropzoneFileInterface>?>? onDropFiles;

  /// Event called when the user drops multiple strings onto the dropzone.
  final ValueChanged<List<String>?>? onDropStrings;

  /// Event called when the user leaves a dropzone.
  final VoidCallback? onLeave;

  const DropzoneView({
    Key? key,
    this.operation,
    this.cursor,
    this.mime,
    this.gestureRecognizers,
    this.onCreated,
    this.onLoaded,
    this.onError,
    this.onHover,
    @Deprecated('Use onDropFile or onDropString instead.') this.onDrop,
    this.onDropFile,
    this.onDropString,
    this.onDropInvalid,
    @Deprecated('Use onDropFiles or onDropStrings instead.') this.onDropMultiple,
    this.onDropFiles,
    this.onDropStrings,
    this.onLeave,
  }) : super(key: key);

  @override
  State<DropzoneView> createState() => DropzoneViewState();
}

class DropzoneViewState extends State<DropzoneView> {
  final _controller = Completer<DropzoneViewController>();
  late ValueChanged<String?>? onError;
  late VoidCallback? onHover;
  @Deprecated('Use onDropFile or onDropString instead.')
  late ValueChanged<dynamic>? onDrop;
  late ValueChanged<DropzoneFileInterface>? onDropFile;
  late ValueChanged<String>? onDropString;
  late ValueChanged<String?>? onDropInvalid;
  @Deprecated('Use onDropFiles or onDropStrings instead.')
  late ValueChanged<List<dynamic>?>? onDropMultiple;
  late ValueChanged<List<DropzoneFileInterface>?>? onDropFiles;
  late ValueChanged<List<String>?>? onDropStrings;
  late VoidCallback? onLeave;

  @override
  void initState() {
    super.initState();
    onError = widget.onError;
    onHover = widget.onHover;
    onDrop = widget.onDrop;
    onDropFile = widget.onDropFile;
    onDropString = widget.onDropString;
    onDropInvalid = widget.onDropInvalid;
    onDropMultiple = widget.onDropMultiple;
    onDropFiles = widget.onDropFiles;
    onDropStrings = widget.onDropStrings;
    onLeave = widget.onLeave;
  }

  @override
  void didUpdateWidget(DropzoneView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (onError != widget.onError) onError = widget.onError;
    if (onHover != widget.onHover) onHover = widget.onHover;
    if (onDrop != widget.onDrop) onDrop = widget.onDrop;
    if (onDropFile != widget.onDropFile) onDropFile = widget.onDropFile;
    if (onDropString != widget.onDropString) onDropString = widget.onDropString;
    if (onDropInvalid != widget.onDropInvalid) onDropInvalid = widget.onDropInvalid;
    if (onDropMultiple != widget.onDropMultiple) onDropMultiple = widget.onDropMultiple;
    if (onDropFiles != widget.onDropFiles) onDropFiles = widget.onDropFiles;
    if (onDropStrings != widget.onDropStrings) onDropStrings = widget.onDropStrings;
    if (onLeave != widget.onLeave) onLeave = widget.onLeave;
  }

  @override
  Widget build(BuildContext context) {
    final params = <String, dynamic>{
      'operation': widget.operation,
      'cursor': widget.cursor,
      'mime': widget.mime,
    };
    return FlutterDropzonePlatform.instance.buildView(
      params,
      widget.gestureRecognizers,
      (viewId) {
        final ctrl = DropzoneViewController._create(viewId, widget, this);
        _controller.complete(ctrl);
        widget.onCreated?.call(ctrl);
        FlutterDropzonePlatform.instance.init(params, viewId: viewId);
      },
    );
  }
}

class DropzoneViewController {
  final int viewId;
  final DropzoneView widget;
  final DropzoneViewState state;

  DropzoneViewController._create(this.viewId, this.widget, this.state) {
    if (widget.onLoaded != null) {
      FlutterDropzonePlatform.instance //
          .onLoaded(viewId: viewId)
          .listen((_) => widget.onLoaded!());
    }
    if (state.onError != null) {
      FlutterDropzonePlatform.instance //
          .onError(viewId: viewId)
          .listen((msg) => state.onError!(msg.value));
    }
    if (state.onHover != null) {
      FlutterDropzonePlatform.instance //
          .onHover(viewId: viewId)
          .listen((msg) => state.onHover!());
    }
    if (state.onDrop != null) {
      FlutterDropzonePlatform.instance //
          .onDrop(viewId: viewId)
          .listen((msg) => state.onDrop!(msg.value));
    }
    if (state.onDropFile != null) {
      FlutterDropzonePlatform.instance //
          .onDropFile(viewId: viewId)
          .listen((msg) => state.onDropFile!(msg.value!));
    }
    if (state.onDropString != null) {
      FlutterDropzonePlatform.instance //
          .onDropString(viewId: viewId)
          .listen((msg) => state.onDropString!(msg.value!));
    }
    if (state.onDropInvalid != null) {
      FlutterDropzonePlatform.instance //
          .onDropInvalid(viewId: viewId)
          .listen((msg) => state.onDropInvalid!(msg.value));
    }
    if (state.onDropMultiple != null) {
      FlutterDropzonePlatform.instance //
          .onDropMultiple(viewId: viewId)
          .listen((msg) => state.onDropMultiple!(msg.value));
    }
    if (state.onDropFiles != null) {
      FlutterDropzonePlatform.instance //
          .onDropFiles(viewId: viewId)
          .listen((msg) => state.onDropFiles!(msg.value!));
    }
    if (state.onDropStrings != null) {
      FlutterDropzonePlatform.instance //
          .onDropStrings(viewId: viewId)
          .listen((msg) => state.onDropStrings!(msg.value!));
    }
    if (state.onLeave != null) {
      FlutterDropzonePlatform.instance //
          .onLeave(viewId: viewId)
          .listen((msg) => state.onLeave!());
    }
  }

  /// Specify the [DragOperation] while dragging the file.
  Future<bool> setOperation(DragOperation operation) {
    return FlutterDropzonePlatform.instance.setOperation(
      operation,
      viewId: viewId,
    );
  }

  /// Specify the [CursorType] of the dropzone. [CursorType] is one the CSS cursor types.
  Future<bool> setCursor(CursorType cursor) async {
    return FlutterDropzonePlatform.instance.setCursor(cursor, viewId: viewId);
  }

  /// Specify the list of accepted MIME types.
  Future<bool> setMIME(List<String> mimes) {
    return FlutterDropzonePlatform.instance.setMIME(mimes, viewId: viewId);
  }

  /// Convenience function to display the browser File Open dialog.
  ///
  /// Set [multiple] to allow picking more than one file.
  /// Returns the list of files picked by the user.
  Future<List<DropzoneFileInterface>> pickFiles({
    bool multiple = false,
    List<String> mime = const [],
  }) {
    return FlutterDropzonePlatform.instance.pickFiles(
      multiple,
      mime: mime,
      viewId: viewId,
    );
  }

  /// Get the filename of the passed HTML file.
  Future<String> getFilename(DropzoneFileInterface file) {
    return FlutterDropzonePlatform.instance.getFilename(file, viewId: viewId);
  }

  /// Get the size of the passed HTML file.
  Future<int> getFileSize(DropzoneFileInterface file) {
    return FlutterDropzonePlatform.instance.getFileSize(file, viewId: viewId);
  }

  /// Get the MIME type of the passed HTML file.
  Future<String> getFileMIME(DropzoneFileInterface file) {
    return FlutterDropzonePlatform.instance.getFileMIME(file, viewId: viewId);
  }

  /// Get the last modified date of the passed HTML file.
  Future<DateTime> getFileLastModified(DropzoneFileInterface file) {
    return FlutterDropzonePlatform.instance.getFileLastModified(
      file,
      viewId: viewId,
    );
  }

  /// Create a temporary URL to the passed HTML file.
  ///
  /// When finished, the URL should be released using [releaseFileUrl()].
  Future<String> createFileUrl(DropzoneFileInterface file) {
    return FlutterDropzonePlatform.instance.createFileUrl(file, viewId: viewId);
  }

  /// Release a temporary URL previously created using [createFileUrl()].
  Future<bool> releaseFileUrl(String fileUrl) {
    return FlutterDropzonePlatform.instance.releaseFileUrl(
      fileUrl,
      viewId: viewId,
    );
  }

  /// Get the contents of the passed HTML file.
  Future<Uint8List> getFileData(DropzoneFileInterface file) {
    return FlutterDropzonePlatform.instance.getFileData(file, viewId: viewId);
  }

  /// Get the contents of the passed HTML file as a chunked stream.
  Stream<List<int>> getFileStream(DropzoneFileInterface file) {
    return FlutterDropzonePlatform.instance.getFileStream(file, viewId: viewId);
  }
}