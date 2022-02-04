import 'dart:io';

import 'plain_firebase_loader.dart';

class CachedPlainFirebaseLoader extends PlainFirebaseLoader {
  const CachedPlainFirebaseLoader();

  @override
  Future<bool> exists(String path) async => (await loadFile(path)) != null;

  @override
  Future<File?> loadFile(String path) async {
    assert(path.isNotEmpty);

    return (await cacheManager.getFileFromCache(path))?.file;
  }
}
