import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:path/path.dart' as p;

import 'loader.dart';
import 'plain_assets_loader.dart';

/// \warning Some files from ultra compression tools (for ex., 7Zip)
/// doesn't extract correctly.
class ZipAssetsLoader extends Loader {
  const ZipAssetsLoader();

  @override
  Future<bool> exists(String path) async {
    assert(path.isNotEmpty);

    final file = await loadFile(path);

    return file?.existsSync() ?? false;
  }

  @override
  Future<File?> loadFile(String path) async {
    assert(path.isNotEmpty);

    print('path `$path`');

    // direct verify into the local path
    final localPathToFile = p.join(await localPath, path);
    var file = File(localPathToFile);
    if (file.existsSync()) {
      return file;
    }

    // decompose the path and extract the file from archive
    // look at any zip file into the assets
    final splits = p.split(p.withoutExtension(path));
    File? foundFile;
    for (var i = splits.length - 1; i >= 0; --i) {
      final subSplits = splits.sublist(0, i);
      final subPath = '${p.joinAll(subSplits)}.zip';
      print('subPath `$subPath`, look into the assets');
      if (await _plainAssetsLoader.exists(subPath)) {
        final subFile = await _plainAssetsLoader.loadFile(subPath);
        print('subFile from assets `$subFile`');
        if (subFile?.existsSync() ?? false) {
          foundFile = subFile;
          break;
        }
      }
    }

    print('foundFile `$foundFile`');
    if (foundFile == null) {
      return null;
    }

    // extract all files from archive
    final bytes = foundFile.readAsBytesSync();
    print('file size `${bytes.length}` bytes');
    final archive = ZipDecoder().decodeBytes(bytes);
    final baseOutPath = p.dirname(foundFile.path);
    for (final file in archive) {
      print('file `$file`');
      final out = p.join(baseOutPath, file.name);
      if (file.isFile) {
        print('getting content from `${file.name}` to `$out`');
        final data = file.content as List<int>;
        File(out)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        print('create directory `$out`');
        Directory(out).createSync(recursive: true);
      }
    }

    file = File(localPathToFile);

    return file.existsSync() ? file : null;
  }

  @override
  Future<widgets.Image?> loadImageWidget(
    String path, {
    double? width,
    double? height,
    widgets.BoxFit? fit,
  }) async {
    assert(path.isNotEmpty);

    final file = await loadFile(path);
    if (file == null) {
      return null;
    }

    return widgets.Image.file(
      file,
      width: width,
      height: height,
      fit: fit,
    );
  }

  @override
  Future<String?> loadString(String path) async {
    assert(path.isNotEmpty);

    final file = await loadFile(path);

    return file?.readAsStringSync();
  }

  static const _plainAssetsLoader = PlainAssetsLoader();
}
