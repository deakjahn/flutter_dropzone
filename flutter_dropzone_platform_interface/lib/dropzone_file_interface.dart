abstract class DropzoneFileInterface {
  String get name; //
  String get type; //
  int get size; //
  int get lastModified; //
  String get webkitRelativePath;

  Object getNative();
}
