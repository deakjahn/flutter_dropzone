import 'package:web/web.dart' as web;

class DropzoneFile {
  final web.File webFile;

  DropzoneFile(this.webFile);

  String get name => webFile.name;

  int get lastModified => webFile.lastModified;

  String get webkitRelativePath => webFile.webkitRelativePath;
}