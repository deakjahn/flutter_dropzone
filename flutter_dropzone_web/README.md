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
  flutter_dropzone: ^1.0.0
  ...
```

Once you have `flutter_dropzone` in `pubspec.yaml` you should be able to use `package:flutter_dropzone` as normal.

### Breaking changes

2.1.0 had to be a breaking change because a bug I reported earlier was fixed in Flutter 2.5 stable: https://github.com/flutter/flutter/issues/56181

Previously, as a workaround, the plugin had its own modified version of `HtmlElementView` but with the fix, it's no longer necessary. However, leaving it out would break
the functioning of the plugin for people how haven't yet moved on to 2.5. You have to stay with the latest 2.0.x version of `flutter_dropzone` if you're not yet ready to upgrade
your Flutter for any reason.

[1]: https://pub.dev/packages/flutter_dropzone
