import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;

import '../../cross_file_manager.dart';
import '../loaders/loader.dart';
import '../log.dart';
import 'memory_cache.dart';

/// \see [assetsCrossFileManager] and [assetsCrossFileManager] for example.
class CrossFileManager {
  static const defImageWidget = Icon(Icons.image, color: Colors.indigoAccent);
  static const defString = '';

  final List<Loader> loaders;
  final Log log;

  /// \warning Doesn't should be singleton.
  final BaseMemoryCache memoryCache;

  static Future<CrossFileManager> create({
    required List<Loader> loaders,
    bool useMemoryCache = true,
    bool needClearCache = false,
    Log log = kDebugMode ? li : liSilent,
  }) async {
    final instance = CrossFileManager._create(
      loaders: loaders,
      useMemoryCache: useMemoryCache,
      log: log,
    );

    if (needClearCache) {
      await instance.clearCache();
    }

    return instance;
  }

  CrossFileManager._create({
    required this.loaders,
    bool useMemoryCache = true,
    this.log = kDebugMode ? li : liSilent,
  })  : assert(loaders.isNotEmpty),
        memoryCache = useMemoryCache ? MemoryCache() : FakeMemoryCache() {
    log('started with `useMemoryCache` $useMemoryCache');
  }

  Future<bool> exists(String path, {List<Loader>? loaders}) async {
    if (loaders == null) {
      log('exists($path) look at into the memory cache...');
      final r = await memoryCache.exists(path);
      if (r != null) {
        log('exists($path) return from memory cache');
        return r;
      }
    }

    for (final loader in loaders ?? this.loaders) {
      log('exists($path) with $loader...');
      if (await loader.exists(path)) {
        log('exists($path) true with $loader.');
        await memoryCache.addExists(path, true);
        return true;
      }
    }

    await memoryCache.addExists(path, false);

    return false;
  }

  /// \see [warmUp]
  Future<bool> existsInCache(String path, {List<Loader>? loaders}) async {
    if (loaders == null) {
      log('existsInCache($path) look at into the memory cache...');
      final r = await memoryCache.exists(path);
      if (r != null) {
        log('existsInCache($path) return from memory cache');
        return r;
      }
    }

    for (final loader in loaders ?? this.loaders) {
      log('existsInCache($path) with $loader...');
      if (await loader.existsInCache(path)) {
        log('existsInCache($path) true with $loader.');
        await memoryCache.addExists(path, true);
        return true;
      }
    }

    await memoryCache.addExists(path, false);

    return false;
  }

  /// Just add [path] to cache for fast access in the future.
  /// \see [existsInCache]
  Future<bool> warmUp(String path, {List<Loader>? loaders}) async {
    for (final loader in loaders ?? this.loaders) {
      log('warmUp($path) with $loader...');
      final success = await loader.warmUp(path);
      if (success) {
        log('warmUp($path) success with $loader.');
        return true;
      }
    }

    return false;
  }

  Future<File?> loadFile(String path, {List<Loader>? loaders}) async {
    if (loaders == null) {
      log('loadFile($path) look at into the memory cache...');
      final r = await memoryCache.getFile(path);
      if (r != null) {
        log('loadFile($path) return from memory cache');
        return r;
      }
    }

    for (final loader in loaders ?? this.loaders) {
      log('loadFile($path) with $loader...');
      final r = await loader.loadFile(path);
      if (r != null) {
        log('loadFile($path) success with $loader: `$r`.');
        await memoryCache.addFile(path, r);
        return r;
      }
    }

    return null;
  }

  Future<widgets.Image?> loadImageWidget(
    String path, {
    List<Loader>? loaders,
    double? width,
    double? height,
    widgets.BoxFit? fit,
    widgets.ImageErrorWidgetBuilder? errorBuilder,
  }) async {
    if (loaders == null) {
      log('loadImageWidget($path) look at into the memory cache...');
      final r = await memoryCache.getImageWidget(path);
      if (r != null) {
        log('loadImageWidget($path) return from memory cache');
        return r;
      }
    }

    for (final loader in loaders ?? this.loaders) {
      log('loadImageWidget($path) with $loader...');
      final r = await loader.loadImageWidget(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: errorBuilder,
      );
      if (r != null) {
        log('loadImageWidget($path) success with $loader: `$r`.');
        await memoryCache.addImageWidget(path, r);
        return r;
      }
    }

    return null;
  }

  Future<widgets.Widget> loadImageWidgetOrDefault(
    String path, {
    List<Loader>? loaders,
    double? width,
    double? height,
    widgets.BoxFit? fit,
    widgets.Image? def,
  }) async =>
      await loadImageWidget(
        path,
        loaders: loaders,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stack) => def ?? defImageWidget,
      ) ??
      def ??
      defImageWidget;

  Future<ui.Image?> loadImageUi(
    String path, {
    List<Loader>? loaders,
  }) async {
    if (loaders == null) {
      log('loadImageUi($path) look at into the memory cache...');
      final r = await memoryCache.getImageUi(path);
      if (r != null) {
        log('loadImageUi($path) return from memory cache');
        return r;
      }
    }

    for (final loader in loaders ?? this.loaders) {
      log('loadImageUi($path) with $loader...');
      final r = await loader.loadImageUi(path);
      if (r != null) {
        log('loadImageUi($path) success with $loader: `$r`.');
        await memoryCache.addImageUi(path, r);
        return r;
      }
    }

    return null;
  }

  Future<String?> loadString(String path, {List<Loader>? loaders}) async {
    if (loaders == null) {
      log('loadString($path) look at into the memory cache...');
      final r = await memoryCache.getString(path);
      if (r != null) {
        log('loadString($path) return from memory cache');
        return r;
      }
    }

    for (final loader in loaders ?? this.loaders) {
      log('loadString($path) with $loader...');
      final r = await loader.loadString(path);
      if (r != null) {
        log('loadString($path) success with $loader: `$r`.');
        await memoryCache.addString(path, r);
        return r;
      } else {
        log('loadString($path) fail with $loader.');
      }
    }

    return null;
  }

  Future<String> loadStringOrDefault(
    String path, {
    List<Loader>? loaders,
    String? def,
  }) async =>
      await loadString(path, loaders: loaders) ?? def ?? defString;

  Future<void> clearCache() async {
    log('clearCache()...');
    await memoryCache.clear();

    for (final loader in loaders) {
      log('clearCache() with $loader.');
      await loader.clearCache();
    }
  }
}
