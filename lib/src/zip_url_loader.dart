import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:path/path.dart' as p;

import 'loader.dart';
import 'plain_url_loader.dart';

class ZipUrlLoader extends Loader {
  final String base;

  @override
  String get temporaryFolder => '${super.temporaryFolder}/zipurl';

  String url(String path) => p.join(base, path);

  const ZipUrlLoader({required this.base}) : assert(base.length > 0);

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

    print('loadFile path `$path`');

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
    for (var i = splits.length - 1; i >= 0; --i) {
      final subSplits = splits.sublist(0, i);
      subPath = '${p.joinAll(subSplits)}.zip';
      print('subPath `$subPath`, look into the url');
      if (await _plainUrlLoader.exists(subPath)) {
        final subFile = await _plainUrlLoader.loadFile(subPath);
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
    final baseOutPath = p.dirname(p.join(await localPath, subPath));
    print('baseOutPath $baseOutPath');
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

    print('localPathToFile `$localPathToFile`');
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

  PlainUrlLoader get _plainUrlLoader => PlainUrlLoader(base: base);
}
