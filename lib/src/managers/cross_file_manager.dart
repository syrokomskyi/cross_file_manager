import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' as widgets;

import '../loaders/loader.dart';
import '../log.dart';

class CrossFileManager {
  static Log log = kDebugMode ? li : liSilent;

  final List<Loader> loaders;

  CrossFileManager({required this.loaders, bool needClearCache = false})
      : assert(loaders.isNotEmpty) {
    if (needClearCache) {
      clearCache();
    }
  }

  Future<bool> exists(String path, {List<Loader>? loaders}) async {
    for (final loader in loaders ?? this.loaders) {
      li('exists($path) with $loader...');
      if (await loader.exists(path)) {
        li('exists($path) true with $loader.');
        return true;
      }
    }

    return false;
  }

  /// \see [warmUp]
  Future<bool> existsInCache(String path, {List<Loader>? loaders}) async {
    for (final loader in loaders ?? this.loaders) {
      li('existsInCache($path) with $loader...');
      if (await loader.existsInCache(path)) {
        li('existsInCache($path) true with $loader.');
        return true;
      }
    }

    return false;
  }

  /// Just add [path] to cache for fast access in the future.
  /// \see [existsInCache]
  Future<bool> warmUp(String path, {List<Loader>? loaders}) async {
    for (final loader in loaders ?? this.loaders) {
      li('warmUp($path) with $loader...');
      final success = await loader.warmUp(path);
      if (success) {
        li('warmUp($path) success with $loader.');
        return true;
      }
    }

    return false;
  }

  Future<File?> loadFile(String path, {List<Loader>? loaders}) async {
    for (final loader in loaders ?? this.loaders) {
      li('loadFile($path) with $loader...');
      final r = await loader.loadFile(path);
      if (r != null) {
        li('loadFile($path) success with $loader: `$r`.');
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
    for (final loader in loaders ?? this.loaders) {
      li('loadImageWidget($path) with $loader...');
      final r = await loader.loadImageWidget(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: errorBuilder,
      );
      if (r != null) {
        li('loadImageWidget($path) success with $loader: `$r`.');
        return r;
      }
    }

    return null;
  }

  Future<String?> loadString(String path, {List<Loader>? loaders}) async {
    for (final loader in loaders ?? this.loaders) {
      li('loadString($path) with $loader...');
      final r = await loader.loadString(path);
      if (r != null) {
        li('loadString($path) success with $loader: `$r`.');
        return r;
      }
    }

    return null;
  }

  Future<void> clearCache() async {
    log('clearCache()...');
    for (final loader in loaders) {
      li('clearCache() with $loader.');
      await loader.clearCache();
    }
  }
}
