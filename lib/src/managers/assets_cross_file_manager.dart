import 'dart:io';
import 'dart:ui' as ui;

import '../loaders/plain_assets_loader.dart';
import '../loaders/zip_assets_loader.dart';
import 'cross_file_manager.dart';

/// \see /example/lib/main.dart
final assetsCrossFileManager = CrossFileManager.create(
  loaders: const [
    PlainAssetsLoader(),
    ZipAssetsLoader(),
  ],
  needClearCache: false,
);

/// Or we can implement same manager to singleton.
class AssetsCrossFileManager {
  static final _instance = AssetsCrossFileManager._();

  static final crossFileManager = CrossFileManager.create(
    // local priority without archive
    loaders: const [
      PlainAssetsLoader(),
      ZipAssetsLoader(),
    ],
    needClearCache: false,
  );

  factory AssetsCrossFileManager() => _instance;

  AssetsCrossFileManager._();

  Future<bool> exists(String path) async =>
      (await crossFileManager).exists(path);

  Future<File?> loadFile(String path) async =>
      (await crossFileManager).loadFile(path);

  Future<ui.Image?> loadImageUi(String path) async =>
      (await crossFileManager).loadImageUi(path);

  Future<String?> loadString(String path) async =>
      (await crossFileManager).loadString(path);
}
