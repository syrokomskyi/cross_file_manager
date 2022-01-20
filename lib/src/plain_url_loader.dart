import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'loader.dart';

class PlainUrlLoader extends Loader {
  final String base;

  String url(String path) => '$base/$path';

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

    CacheManager.logLevel = kDebugMode
        ? CacheManagerLogLevel.verbose
        : CacheManagerLogLevel.warning;

    /* \todo Add `loadFileStream()`.
    cacheManager.getFileStream(
      pathWithBase(path),
      withProgress: true,
    );
    */

    final fileInfo = await cacheManager.downloadFile(url(path));

    return fileInfo.file;
  }

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
