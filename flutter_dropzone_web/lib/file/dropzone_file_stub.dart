import 'package:flutter_dropzone_platform_interface/flutter_dropzone_platform_interface.dart';

DropzoneFileInterface createFile(Object native) {
  throw UnsupportedError(
    'Cannot create a file without dart:js_interop or dart:io.',
  );
}
