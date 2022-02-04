import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:stash/stash_api.dart';
import 'package:stash_memory/stash_memory.dart';

/// Memorize all data which was requested and saved to local.
abstract class BaseMemoryCache {
  final MemoryCacheStore _store;

  // \todo Define limits into the config.
  // \todo Wrap to own Cache<T>?
  @protected
  late final Cache<bool?> cacheExists;

  @protected
  late final Cache<bool?> cacheWarmUp;

  @protected
  late final Cache<File?> cacheFile;

  @protected
  late final Cache<widgets.Widget?> cacheImageWidget;

  @protected
  late final Cache<String?> cacheString;

  BaseMemoryCache() : _store = newMemoryCacheStore() {
    cacheExists = _store.cache<bool>(name: 'exists', maxEntries: 400);
    cacheFile = _store.cache<File?>(name: 'file', maxEntries: 50);
    cacheImageWidget =
        _store.cache<widgets.Widget?>(name: 'image_widget', maxEntries: 50);
    cacheString = _store.cache<String>(name: 'string', maxEntries: 100);
  }

  Future<bool?> exists(String path);

  Future<void> addExists(String path, bool r);

  Future<File?> getFile(String path);

  Future<void> addFile(String path, File r);

  Future<widgets.Widget?> getImageWidget(String path);

  Future<void> addImageWidget(String path, widgets.Widget r);

  Future<String?> getString(String path);

  Future<void> addString(String path, String r);

  Future<void> clear();
}

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
  Future<widgets.Widget?> getImageWidget(String path) async =>
      cacheImageWidget.get(path);

  @override
  Future<void> addImageWidget(String path, widgets.Widget r) async =>
      cacheImageWidget.putIfAbsent(path, r);

  @override
  Future<String?> getString(String path) async => cacheString.get(path);

  @override
  Future<void> addString(String path, String r) async =>
      cacheString.putIfAbsent(path, r);

  @override
  Future<void> clear() async => _store.deleteAll();
}

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
  Future<widgets.Widget?> getImageWidget(String path) async => null;

  @override
  Future<void> addImageWidget(String path, widgets.Widget r) async {}

  @override
  Future<String?> getString(String path) async => null;

  @override
  Future<void> addString(String path, String r) async {}

  @override
  Future<void> clear() async {}
}
