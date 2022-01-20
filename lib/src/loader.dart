import 'dart:async' show Completer;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract class Loader {
  const Loader();

  /// Overwrite this when a custom loader using a cache.
  /// \see [clearCache]
  @mustCallSuper
  String get temporaryFolder => 'cfm';

  /// \see [clearCache]
  /// \see [temporaryFolder]
  Future<String> get localPath async {
    final tempDir = await getTemporaryDirectory();
    final path = p.join(tempDir.path, temporaryFolder);
    if (!File(path).existsSync()) {
      Directory(path).createSync(recursive: true);
    }

    return path;
  }

  DefaultCacheManager get cacheManager => DefaultCacheManager();

  Future<bool> exists(String path);

  Future<bool> notExists(String path) async => !(await exists(path));

  Future<File?> loadFile(String path);

  Future<String?> loadString(String path);

  Future<widgets.Image?> loadImageWidget(
    String path, {
    double? width,
    double? height,
    widgets.BoxFit? fit,
  });

  /// \see [localPath]
  /// \see [temporaryFolder]
  Future<void> clearCache() async {
    final dir = Directory(await localPath);
    if (dir.existsSync()) {
      await dir.delete(recursive: true);
    }

    cacheManager.emptyCache();
  }

  @protected
  static Future<ui.Image> convertBytesToImage(Uint8List bytes) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, completer.complete);
    return completer.future;
  }
}
