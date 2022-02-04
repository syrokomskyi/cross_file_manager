import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:stash/stash_api.dart';
import 'package:stash_memory/stash_memory.dart';

final _store = newMemoryCacheStore();

/// Memorize all data which was requested and saved to local.
abstract class BaseMemoryCache {
  // \todo Define limits into the config.
  // \todo Wrap to own Cache<T>?
  @protected
  final cacheExists = _store.cache<bool>(name: 'exists', maxEntries: 400);

  @protected
  final cacheWarmUp = _store.cache<bool>(name: 'warm_up', maxEntries: 400);

  @protected
  final cacheFile = _store.cache<File?>(name: 'file', maxEntries: 50);

  @protected
  final cacheImageWidget =
      _store.cache<widgets.Widget?>(name: 'image_widget', maxEntries: 50);

  @protected
  final cacheString = _store.cache<String>(name: 'string', maxEntries: 100);

  Future<bool> exists(String path);

  Future<void> addExists(String path);

  Future<bool> hasWarmUp(String path);

  Future<void> addHasWarmUp(String path);

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
  Future<bool> exists(String path) async =>
      (await cacheExists.get(path)) ?? false;

  @override
  Future<void> addExists(String path) async =>
      cacheExists.putIfAbsent(path, true);

  @override
  Future<bool> hasWarmUp(String path) async =>
      (await cacheWarmUp.get(path)) ?? false;

  @override
  Future<void> addHasWarmUp(String path) async =>
      cacheWarmUp.putIfAbsent(path, true);

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
  Future<bool> exists(String path) async => false;

  @override
  Future<void> addExists(String path) async {}

  @override
  Future<bool> hasWarmUp(String path) async => false;

  @override
  Future<void> addHasWarmUp(String path) async {}

  @override
  Future<File?> getFile(String path) async {}

  @override
  Future<void> addFile(String path, File r) async {}

  @override
  Future<widgets.Widget?> getImageWidget(String path) async {}

  @override
  Future<void> addImageWidget(String path, widgets.Widget r) async {}

  @override
  Future<String?> getString(String path) async {}

  @override
  Future<void> addString(String path, String r) async {}

  @override
  Future<void> clear() async {}
}
