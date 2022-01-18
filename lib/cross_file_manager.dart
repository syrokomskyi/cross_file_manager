library cross_file_manager;

import 'dart:async' show Completer;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

class CrossFileManager {
  final List<Loader> loaders;

  const CrossFileManager({required this.loaders}) : assert(loaders.length > 0);

  Future<bool> exists(String path) async {
    for (final loader in loaders) {
      if (await loader.exists(path)) {
        return true;
      }
    }

    return false;
  }

  Future<ui.Image?> loadImage(String path) async {
    for (final loader in loaders) {
      final r = await loader.loadImage(path);
      if (r != null) {
        return r;
      }
    }

    return null;
  }
}

class AssetCrossFileManager extends CrossFileManager {
  static final AssetCrossFileManager _instance = AssetCrossFileManager._();

  factory AssetCrossFileManager() {
    return _instance;
  }

  AssetCrossFileManager._() : super(loaders: const [AssetsLoader()]);
}

abstract class Loader {
  const Loader();

  Future<bool> exists(String path);

  Future<String?> loadString(String path);

  Future<Uint8List?> loadBytes(String path);

  Future<ui.Image?> loadImage(String path) async {
    final bytes = await loadBytes(path);
    return bytes == null ? null : convertBytesToImage(bytes);
  }

  @protected
  static Future<ui.Image> convertBytesToImage(Uint8List bytes) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, completer.complete);
    return completer.future;
  }
}

class AssetsLoader extends Loader {
  const AssetsLoader();

  @override
  Future<bool> exists(String path) async {
    assert(path.isNotEmpty);
    try {
      await rootBundle.load(path);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String?> loadString(String path) => rootBundle.loadString(path);

  @override
  Future<Uint8List?> loadBytes(String path) async {
    final data = await rootBundle.load(path);
    return Uint8List.view(data.buffer);
  }
}
