library cross_file_manager;

import 'dart:async' show Completer;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart' as widgets;

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

  Future<widgets.Image?> loadImageWidget(
    String path, {
    double? width,
    double? height,
    widgets.BoxFit? fit,
  }) async {
    for (final loader in loaders) {
      final r = await loader.loadImageWidget(
        path,
        width: width,
        height: height,
        fit: fit,
      );
      if (r != null) {
        return r;
      }
    }

    return null;
  }

  Future<String?> loadString(String path) async {
    for (final loader in loaders) {
      final r = await loader.loadString(path);
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

  Future<widgets.Image?> loadImageWidget(
    String path, {
    double? width,
    double? height,
    widgets.BoxFit? fit,
  });

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
    if (path.isEmpty) {
      return false;
    }

    try {
      await rootBundle.load(path);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Uint8List?> loadBytes(String path) async {
    final data = await rootBundle.load(path);
    return Uint8List.view(data.buffer);
  }

  @override
  Future<widgets.Image?> loadImageWidget(
    String path, {
    double? width,
    double? height,
    widgets.BoxFit? fit,
  }) async {
    try {
      return widgets.Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> loadString(String path) async => rootBundle.loadString(path);
}
