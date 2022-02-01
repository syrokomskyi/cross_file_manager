import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' as widgets;

import 'loader.dart';

class CrossFileManager {
  static bool log = kDebugMode;

  final List<Loader> loaders;

  CrossFileManager({required this.loaders, bool needClearCache = false})
      : assert(loaders.isNotEmpty) {
    if (needClearCache) {
      clearCache();
    }
  }

  Future<bool> exists(String path, {List<Loader>? loaders}) async {
    for (final loader in loaders ?? this.loaders) {
      if (await loader.exists(path)) {
        return true;
      }
    }

    return false;
  }

  /// Just add [path] to cache for fast access in the future.
  Future<bool> warmUp(String path, {List<Loader>? loaders}) async {
    for (final loader in loaders ?? this.loaders) {
      final success = await loader.warmUp(path);
      if (success) {
        return true;
      }
    }

    return false;
  }

  Future<File?> loadFile(String path, {List<Loader>? loaders}) async {
    for (final loader in loaders ?? this.loaders) {
      final r = await loader.loadFile(path);
      if (r != null) {
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
      final r = await loader.loadImageWidget(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: errorBuilder,
      );
      if (r != null) {
        return r;
      }
    }

    return null;
  }

  Future<String?> loadString(String path, {List<Loader>? loaders}) async {
    for (final loader in loaders ?? this.loaders) {
      final r = await loader.loadString(path);
      if (r != null) {
        return r;
      }
    }

    return null;
  }

  Future<void> clearCache() async {
    for (final loader in loaders) {
      await loader.clearCache();
    }
  }
}
