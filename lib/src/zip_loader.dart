import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' as widgets;

import 'loader.dart';

abstract class ZipLoader extends Loader {
  @override
  @mustCallSuper
  String get temporaryFolder => '${super.temporaryFolder}/zip';

  @protected
  Loader get sourceLoader;

  const ZipLoader();

  @override
  Future<bool> exists(String path) async {
    assert(path.isNotEmpty);

    late final File? file;
    try {
      file = await loadFile(path);
    } on HttpException {
      // it's OK: a state can be 404 or any
      file = null;
    }

    return file?.existsSync() ?? false;
  }

  @override
  Future<File?> loadFile(String path);

  @override
  Future<widgets.Image?> loadImageWidget(
    String path, {
    double? width,
    double? height,
    widgets.BoxFit? fit,
  }) async {
    assert(path.isNotEmpty);

    final file = await loadFile(path);
    if (file == null) {
      return null;
    }

    return widgets.Image.file(
      file,
      width: width,
      height: height,
      fit: fit,
    );
  }

  @override
  Future<String?> loadString(String path) async {
    assert(path.isNotEmpty);

    final file = await loadFile(path);

    return file?.readAsStringSync();
  }
}
