import 'dart:io';

import 'package:flutter/widgets.dart' as widgets;

import '../cross_file_manager.dart';

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

  Future<void> clearCache() async =>
      loaders.forEach((loader) => loader.clearCache());
}
