# flutter_dropzone_web

The web implementation of [`flutter_dropzone`][1].

## Usage

### Import the package

This package is the endorsed implementation of `flutter_dropzone` for the web platform, so it gets automatically added to your dependencies by depending on `flutter_dropzone`.

No modifications to your `pubspec.yaml` should be required in a recent enough version of Flutter (`>=1.12.13+hotfix.4`):

```yaml
...
dependencies:
  ...
  flutter_dropzone: ^4.0.0
  ...
```

Once you have `flutter_dropzone` in `pubspec.yaml` you should be able to use `package:flutter_dropzone` as normal.

## Breaking changes

4.2.0 had to introduce another breaking change, sorry. While 4.1.0 solved the problem for web users, it created a regression
for some other people who author multiplatorm apps where not all variants are web-based. Instead of returning a `web.File` directly,
the `onDrop` variants now return a `DropzoneFile`. You can go on accessing its properties as before, so you might not even note
the difference.

4.1.0 deprecates `onDrop` and all other functions using `dynamic` type because the newer Flutter JS support enforces
stricter type checking. `onDrop` will be removed in a coming version. Use `onDropFile` and `onDropString` instead.

4.0.0 is a breaking change because Flutter is actively working on the underlying web support and we're trying to follow suit.
See: https://github.com/deakjahn/flutter_dropzone/issues/78

3.0.0 had to be a breaking change because a bug I reported earlier was fixed in Flutter 2.5 stable: https://github.com/flutter/flutter/issues/56181

Previously, as a workaround, the plugin had its own modified version of `HtmlElementView` but with the fix, it's no longer necessary. However, leaving it out would break
the functioning of the plugin for people who haven't yet moved on to 2.5. You have to stay with the latest 2.0.x version of `flutter_dropzone` if you're not yet ready to upgrade
your Flutter for any reason.

[1]: https://pub.dev/packages/flutter_dropzone