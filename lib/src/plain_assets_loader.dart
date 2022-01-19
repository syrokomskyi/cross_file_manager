import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart' as widgets;
import 'package:path_provider/path_provider.dart';

import 'loader.dart';

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
