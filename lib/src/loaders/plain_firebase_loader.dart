import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cache_manager_firebase/flutter_cache_manager_firebase.dart';

import 'loader.dart';

class PlainFirebaseLoader extends Loader {
  const PlainFirebaseLoader();

  @override
  CacheManager get cacheManager => FirebaseCacheManager();

  @override
  Future<bool> exists(String path) async {
    assert(path.isNotEmpty);

    late final File? file;
    try {
      file = await loadFile(path);
    } on Exception {
      // it's OK: a state can be 404 or any
      log("$runtimeType exists() doesn't found `$path`");
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

    try {
      return (await cacheManager.downloadFile(path)).file;
    } on Exception {
      // it's OK: a state can be 404 or any
      log("$runtimeType loadFile() doesn't load `$path`");
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
