import 'dart:io' show File;

import 'package:path/path.dart' as p;

import 'zip_firebase_loader.dart';

/// The loader for load and trasform data from ZIP-archives from Firebase
/// with caching loaded data.
/// \warning Some files from ultra compression tools (for ex., 7Zip)
/// doesn't extract correctly.
class CachedZipFirebaseLoader extends ZipFirebaseLoader {
  const CachedZipFirebaseLoader();

  @override
  Future<bool> exists(String path) async => (await loadFile(path)) != null;

  @override
  Future<File?> loadFile(String path) async {
    assert(path.isNotEmpty);

    // direct verify into the url path (was copied [ZipFirebaseLoader])
    final localPathToFile = p.join(await localPath, path);
    final file = File(localPathToFile);

    return file.existsSync() ? file : null;
  }
}
