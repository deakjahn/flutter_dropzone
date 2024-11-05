import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter_dropzone_platform_interface/flutter_dropzone_platform_interface.dart';

DropzoneFileInterface createFile(Object native) {
  return DropzoneFileDummy();
}

class DropzoneFileDummy implements DropzoneFileInterface {
  @override
  String get name => '';

  @override
  String get type => '';

  @override
  int get size => 0;

  @override
  int get lastModified => 0;

  @override
  String get webkitRelativePath => '';

  @override
  Object getNative() {
    throw UnsupportedError(
        'DropzoneFileDummy.getNative: $defaultTargetPlatform is not supported');
  }
}