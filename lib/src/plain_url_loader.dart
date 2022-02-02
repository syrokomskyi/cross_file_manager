import 'dart:io';

import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;

import 'cross_file_manager.dart';
import 'loader.dart';
import 'log.dart';

class PlainUrlLoader extends Loader {
  final String base;

  String url(String path) => p.join(base, path);

  const PlainUrlLoader({required this.base}) : assert(base.length > 0);

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
  Future<File?> loadFile(String path) async {
    assert(path.isNotEmpty);

    CacheManager.logLevel = CrossFileManager.log == li
        ? CacheManagerLogLevel.verbose
        : CacheManagerLogLevel.warning;

    /* \todo Add `loadFileStream()`.
    cacheManager.getFileStream(
      pathWithBase(path),
      withProgress: true,
    );
    */

    try {
      return (await cacheManager.downloadFile(url(path))).file;
    } on HttpException {
      // it's OK: a state can be 404 or any
    }

    return null;
  }

  @override
  Future<widgets.Widget?> loadImageWidget(
    String path, {
    double? width,
    double? height,
    widgets.BoxFit? fit,
    widgets.ImageErrorWidgetBuilder? errorBuilder,
  }) async {
    assert(path.isNotEmpty);

    final file = await loadFile(path);

    return file == null
        ? null
        : widgets.Image.file(
            file,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: errorBuilder,
          );
  }

  @override
  Future<String?> loadString(String path) async {
    assert(path.isNotEmpty);

    final file = await loadFile(path);

    return file?.readAsStringSync();
  }
}
