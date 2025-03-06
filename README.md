[![pub package](https://img.shields.io/pub/v/flutter_dropzone.svg)](https://pub.dev/packages/flutter_dropzone)

See the README files of the individual subprojects:

* The [main implementation][1] of `flutter_dropzone`.
* The [platform interface][2] of `flutter_dropzone`.
* The [web implementation][3] of `flutter_dropzone`.

## Breaking changes

4.2.0 had to introduce another breaking change, sorry. While 4.1.0 solved the problem for web users, it created a regression
for some other people who author multiplatorm apps where not all variants are web-based. Instead of returning a `web.File` directly,
the `onDrop` variants now return a `DropzoneFileInterface`. You can go on accessing its properties as before, so you might not even notice
the difference.

4.1.0 deprecates `onDrop` and all other functions using `dynamic` type because the newer Flutter JS support enforces
stricter type checking. `onDrop` will be removed in a coming version. Use `onDropFile` and `onDropString` instead.

4.0.x is compatible with Flutter 3.13 (stable) and later. If you're not yet ready to upgrade from a previous version of Flutter, stay with the latest 3.0.x version of `flutter_dropzone`.
See the [README of the web implementation][3] for details.

3.0.x is compatible with Flutter 2.5 (stable) and later. If you're not yet ready to upgrade from a previous version of Flutter, stay with the latest 2.0.x version of `flutter_dropzone`.
See the [README of the web implementation][3] for details.

# Support

If you like this package, please consider supporting it.

<a href="https://www.buymeacoffee.com/deakjahn" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Book" height="60" width="217"></a>

[1]: flutter_dropzone/README.md
[2]: flutter_dropzone_platform_interface/README.md
[3]: flutter_dropzone_web/README.md