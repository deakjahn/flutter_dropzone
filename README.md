See the README files of the individual subprojects:

* The [main implementation][1] of `flutter_dropzone`.
* The [platform interface][2] of `flutter_dropzone`.
* The [web implementation][3] of `flutter_dropzone`.

## Breaking changes

4.1.0 deprecates `onDrop` and all other functions using `dynamic` type because the newer Flutter JS support enforces
stricter type checking. `onDrop` will be removed in a coming version. Use `onDropFile` and `onDropString` instead.

4.0.x is compatible with Flutter 3.13 (stable) and later. If you're not yet ready to upgrade from a previous version of Flutter, stay with the latest 3.0.x version of `flutter_dropzone`.
See the [README of the web implementation][3] for details.

3.0.x is compatible with Flutter 2.5 (stable) and later. If you're not yet ready to upgrade from a previous version of Flutter, stay with the latest 2.0.x version of `flutter_dropzone`.
See the [README of the web implementation][3] for details.

[1]: flutter_dropzone/README.md
[2]: flutter_dropzone_platform_interface/README.md
[3]: flutter_dropzone_web/README.md