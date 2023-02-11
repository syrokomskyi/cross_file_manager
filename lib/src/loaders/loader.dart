import 'dart:async' show Completer;
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../log.dart';

/// The base class for load and transform resources to Dart & Flutter objects.
abstract class Loader {
  final Log log;

  const Loader({
    this.log = kDebugMode ? li : liSilent,
  });

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

  /// The cache for [Loader].
  CacheManager get cacheManager => DefaultCacheManager();

  /// \return `true` then file by [path] exists.
  Future<bool> exists(String path);

  /// \return `true` then file by [path] exists in cache.
  Future<bool> existsInCache(String path) async {
    assert(path.isNotEmpty);

    return (await cacheManager.getFileFromCache(path)) != null;
  }

  /// \see [exists]
  Future<bool> notExists(String path) async => !(await exists(path));

  // Just touch a file by [path] for store it to cache.
  /// \return `true` then file by [path] was found.
  Future<bool> warmUp(String path) async {
    try {
      return (await loadFile(path)) != null;
    } catch (_) {
      return false;
    }
  }

  /// \return [File] object by [path].
  Future<File?> loadFile(String path);

  /// \return [String] by [path].
  Future<String?> loadString(String path);

  /// \return [widgets.Image] object by [path].
  Future<widgets.Image?> loadImageWidget(
    String path, {
    double? width,
    double? height,
    widgets.BoxFit? fit,
    widgets.ImageErrorWidgetBuilder? errorBuilder,
  });

  /// \return [ui.Image] object by [path].
  Future<ui.Image?> loadImageUi(String path) async {
    final file = await loadFile(path);
    if (file == null) {
      return null;
    }

    final bytes = file.readAsBytesSync();
    final codec = await ui.instantiateImageCodec(bytes);
    final frameInfo = await codec.getNextFrame();

    return frameInfo.image;
  }

  /// Clear cache for this [Loader].
  /// \see [localPath]
  /// \see [temporaryFolder]
  Future<void> clearCache() async {
    final dir = Directory(await localPath);
    if (dir.existsSync()) {
      await dir.delete(recursive: true);
    }

    await cacheManager.emptyCache();
  }

  /// \return Converted [Uint8List] to [ui.Image].
  @protected
  static Future<ui.Image> convertBytesToImage(Uint8List bytes) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, completer.complete);
    return completer.future;
  }

  @override
  String toString() => '$runtimeType';
}
