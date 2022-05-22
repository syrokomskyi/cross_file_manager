import 'dart:io';

import 'package:flutter/widgets.dart' as widgets;

import 'loader.dart';

class PlainFileLoader extends Loader {
  const PlainFileLoader();

  @override
  Future<bool> exists(String path) async {
    assert(path.isNotEmpty);

    return File(path).existsSync();
  }

  @override
  Future<File?> loadFile(String path) async {
    assert(path.isNotEmpty);

    if (await notExists(path)) {
      return null;
    }

    return File(path);
  }

  @override
  Future<widgets.Image?> loadImageWidget(
    String path, {
    double? width,
    double? height,
    widgets.BoxFit? fit,
    widgets.ImageErrorWidgetBuilder? errorBuilder,
  }) async {
    assert(path.isNotEmpty);

    return await exists(path)
        ? widgets.Image.file(
            File(path),
            width: width,
            height: height,
            fit: fit,
            errorBuilder: errorBuilder,
          )
        : null;
  }

  @override
  Future<String?> loadString(String path) async =>
      (await loadFile(path))?.readAsStringSync();
}
