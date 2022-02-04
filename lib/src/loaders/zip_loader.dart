import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:path/path.dart' as p;

import '../log.dart';
import 'loader.dart';

abstract class ZipLoader extends Loader {
  @override
  @mustCallSuper
  String get temporaryFolder => '${super.temporaryFolder}/zip';

  @protected
  Loader get sourceLoader;

  const ZipLoader();

  @override
  Future<bool> exists(String path) async {
    assert(path.isNotEmpty);

    late final File? file;
    try {
      file = await loadFile(path);
    } on HttpException {
      // it's OK: a state can be 404 or any
      file = null;
    }

    return file?.existsSync() ?? false;
  }

  @override
  Future<File?> loadFile(String path) async {
    assert(path.isNotEmpty);

    /* \todo Add `loadFileStream()`.
    cacheManager.getFileStream(
      pathWithBase(path),
      withProgress: true,
    );
    */

    li('$runtimeType loadFile path `$path`');

    // direct verify into the url path (was copied below)
    final localPathToFile = p.join(await localPath, path);
    var file = File(localPathToFile);
    if (file.existsSync()) {
      return file;
    }

    // decompose the path, download and extract the file from archive
    // look at any zip file into the url
    final splits = p.split(p.withoutExtension(path));
    File? foundFile;
    late String subPath;
    for (var i = splits.length - 1; i > 0; --i) {
      final subSplits = splits.sublist(0, i);
      subPath = '${p.joinAll(subSplits)}.zip';
      li('$runtimeType subPath `$subPath` for search `$path`');
      if (await sourceLoader.exists(subPath)) {
        final subFile = await sourceLoader.loadFile(subPath);
        li('$runtimeType subFile from assets `$subFile`');
        if (subFile?.existsSync() ?? false) {
          foundFile = subFile;
          break;
        }
      }
    }

    if (foundFile == null) {
      li('$runtimeType not found file by path segments $splits');
      return null;
    } else {
      li('$runtimeType found file `$foundFile` by path segments $splits');
    }

    // extract all files from archive
    final bytes = foundFile.readAsBytesSync();
    li('$runtimeType file size `${bytes.length}` bytes');
    final archive = ZipDecoder().decodeBytes(bytes);
    final baseOutPath = p.dirname(p.join(await localPath, subPath));
    li('$runtimeType baseOutPath $baseOutPath');
    for (final file in archive) {
      li('$runtimeType file `$file`');
      final out = p.join(baseOutPath, file.name);
      if (file.isFile) {
        li('$runtimeType getting content from `${file.name}` to `$out`');
        final data = file.content as List<int>;
        File(out)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        li('$runtimeType create directory `$out`');
        Directory(out).createSync(recursive: true);
      }
    }

    li('$runtimeType localPathToFile `$localPathToFile`');
    file = File(localPathToFile);

    return file.existsSync() ? file : null;
  }

  @override
  Future<widgets.Widget?> loadImageWidget(
    String path, {
    double? width,
    double? height,
    widgets.BoxFit? fit,
    widgets.ImageErrorWidgetBuilder? errorBuilder,
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
      errorBuilder: errorBuilder,
    );
  }

  @override
  Future<String?> loadString(String path) async {
    assert(path.isNotEmpty);

    final file = await loadFile(path);

    return file?.readAsStringSync();
  }
}
