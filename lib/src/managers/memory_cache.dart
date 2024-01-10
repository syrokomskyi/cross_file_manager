import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:stash/stash_api.dart';
import 'package:stash_memory/stash_memory.dart';

/// Memorize all data which was requested and saved to local.
/// \warning Run `initOnce()` for initialize instance.
abstract class BaseMemoryCache {
  BaseMemoryCache();

  late final MemoryCacheStore _store;

  /// \todo Define limits into the config.
  /// \todo Wrap to own Cache<T>?
  @protected
  late final Cache<bool?> cacheExists;

  @protected
  late final Cache<bool?> cacheWarmUp;

  @protected
  late final Cache<File?> cacheFile;

  @protected
  late final Cache<widgets.Image?> cacheImageWidget;

  @protected
  late final Cache<ui.Image?> cacheImageUi;

  @protected
  late final Cache<String?> cacheString;

  bool _initOnce = false;

  /// Call this method always after create any [BaseMemoryCache] object.
  Future<void> initOnce() async {
    if (_initOnce) {
      return;
    }

    _initOnce = true;

    _store = await newMemoryCacheStore();
    cacheExists = await _store.cache<bool>(name: 'exists', maxEntries: 400);
    cacheFile = await _store.cache<File?>(name: 'file', maxEntries: 50);
    cacheImageWidget = await _store.cache<widgets.Image?>(
        name: 'image_widget', maxEntries: 50);
    cacheImageUi =
        await _store.cache<ui.Image?>(name: 'image_ui', maxEntries: 50);
    cacheString = await _store.cache<String>(name: 'string', maxEntries: 100);
  }

  Future<bool?> exists(String path);

  Future<void> addExists(String path, bool r);

  Future<File?> getFile(String path);

  Future<void> addFile(String path, File r);

  Future<widgets.Image?> getImageWidget(String path);

  Future<void> addImageWidget(String path, widgets.Image r);

  Future<ui.Image?> getImageUi(String path);

  Future<void> addImageUi(String path, ui.Image r);

  Future<String?> getString(String path);

  Future<void> addString(String path, String r);

  Future<void> clear() async => _store.deleteAll();
}

/// Standard memory cache.
class MemoryCache extends BaseMemoryCache {
  @override
  Future<bool?> exists(String path) async => cacheExists.get(path);

  @override
  Future<void> addExists(String path, bool r) async =>
      cacheExists.putIfAbsent(path, r);

  @override
  Future<File?> getFile(String path) async => cacheFile.get(path);

  @override
  Future<void> addFile(String path, File r) async =>
      cacheFile.putIfAbsent(path, r);

  @override
  Future<widgets.Image?> getImageWidget(String path) async =>
      cacheImageWidget.get(path);

  @override
  Future<void> addImageWidget(String path, widgets.Image r) async =>
      cacheImageWidget.putIfAbsent(path, r);

  @override
  Future<ui.Image?> getImageUi(String path) async => cacheImageUi.get(path);

  @override
  Future<void> addImageUi(String path, ui.Image r) async =>
      cacheImageUi.putIfAbsent(path, r);

  @override
  Future<String?> getString(String path) async => cacheString.get(path);

  @override
  Future<void> addString(String path, String r) async =>
      cacheString.putIfAbsent(path, r);
}

/// Fake cache (doesn't cache anything).
class FakeMemoryCache extends BaseMemoryCache {
  @override
  Future<bool?> exists(String path) async => null;

  @override
  Future<void> addExists(String path, bool r) async {}

  @override
  Future<File?> getFile(String path) async => null;

  @override
  Future<void> addFile(String path, File r) async {}

  @override
  Future<widgets.Image?> getImageWidget(String path) async => null;

  @override
  Future<void> addImageWidget(String path, widgets.Image r) async {}

  @override
  Future<ui.Image?> getImageUi(String path) async => null;

  @override
  Future<void> addImageUi(String path, ui.Image r) async {}

  @override
  Future<String?> getString(String path) async => null;

  @override
  Future<void> addString(String path, String r) async {}
}
