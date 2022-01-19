library cross_file_manager;

import 'dart:async' show Completer;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart' as widgets;
import 'package:path_provider/path_provider.dart';

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

  Future<File?> loadFile(String path) async {
    for (final loader in loaders) {
      final r = await loader.loadFile(path);
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

  AssetCrossFileManager._() : super(loaders: const [PlainAssetsLoader()]);
}

abstract class Loader {
  const Loader();

  Future<bool> exists(String path);

  Future<File?> loadFile(String path);

  Future<String?> loadString(String path);

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

class PlainAssetsLoader extends Loader {
  const PlainAssetsLoader();

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
  Future<File?> loadFile(String path) async {
    final bytes = await rootBundle.load(path);
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    final prepared =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    await file.writeAsBytes(prepared);

    return file;
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
