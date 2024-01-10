import 'dart:io';
import 'dart:ui' as ui;

import '../loaders/plain_assets_loader.dart';
import '../loaders/zip_assets_loader.dart';
import 'cross_file_manager.dart';

/// The file manager for load data from local assets. Variant 1 (variable).
/// \see /example/lib/main.dart
final assetsCrossFileManager = CrossFileManager.create(
  loaders: const [
    PlainAssetsLoader(),
    ZipAssetsLoader(),
  ],
  needClearCache: false,
);

/// Or we can implement same manager to singleton.
/// The file manager for load data from local assets. Variant 2 (class).
class AssetsCrossFileManager {
  factory AssetsCrossFileManager() => _instance;

  AssetsCrossFileManager._();

  static final _instance = AssetsCrossFileManager._();

  static final crossFileManager = CrossFileManager.create(
    // local priority without archive
    loaders: const [
      PlainAssetsLoader(),
      ZipAssetsLoader(),
    ],
    needClearCache: false,
  );

  /// \see [CrossFileManager.exists]
  Future<bool> exists(String path) async =>
      (await crossFileManager).exists(path);

  /// \see [CrossFileManager.loadFile]
  Future<File?> loadFile(String path) async =>
      (await crossFileManager).loadFile(path);

  /// \see [CrossFileManager.loadImageUi]
  Future<ui.Image?> loadImageUi(String path) async =>
      (await crossFileManager).loadImageUi(path);

  /// \see [CrossFileManager.loadString]
  Future<String?> loadString(String path) async =>
      (await crossFileManager).loadString(path);
}
