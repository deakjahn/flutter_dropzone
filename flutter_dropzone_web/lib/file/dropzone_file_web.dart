import 'package:flutter_dropzone_platform_interface/flutter_dropzone_platform_interface.dart';
import 'package:web/web.dart' as web;

DropzoneFileInterface createFile(web.File native) {
  return DropzoneFileWeb(native);
}

class DropzoneFileWeb implements DropzoneFileInterface {
  final web.File webFile;

  DropzoneFileWeb(this.webFile);

  @override
  String get name => webFile.name;

  @override
  String get type => webFile.type;

  @override
  int get size => webFile.size;

  @override
  int get lastModified => webFile.lastModified;

  @override
  String get webkitRelativePath => webFile.webkitRelativePath;

  @override
  web.File getNative() => webFile;
}
