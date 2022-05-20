import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' as widgets;

import '../loaders/loader.dart';
import '../log.dart';
import 'memory_cache.dart';

class CrossFileManager {
  final List<Loader> loaders;
  final Log log;

  /// \warning Doesn't should be singleton.
  final BaseMemoryCache memoryCache;

  CrossFileManager({
    required this.loaders,
    bool useMemoryCache = true,
    bool needClearCache = false,
    this.log = kDebugMode ? li : liSilent,
  })  : assert(loaders.isNotEmpty),
        memoryCache = useMemoryCache ? MemoryCache() : FakeMemoryCache() {
    log('started with `useMemoryCache` $useMemoryCache'
        ' `needClearCache` $needClearCache');
    if (needClearCache) {
      clearCache();
    }
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

  Future<widgets.Widget?> loadImageWidget(
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

  Future<void> clearCache() async {
    log('clearCache()...');
    await memoryCache.clear();

    for (final loader in loaders) {
      log('clearCache() with $loader.');
      await loader.clearCache();
    }
  }
}
