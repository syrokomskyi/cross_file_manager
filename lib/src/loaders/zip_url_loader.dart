import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import 'loader.dart';
import 'plain_url_loader.dart';
import 'zip_loader.dart';

/// The loader for load and trasform data from ZIP-archives from Internet.
class ZipUrlLoader extends ZipLoader {
  final String base;

  @override
  @mustCallSuper
  String get temporaryFolder => '${super.temporaryFolder}/zu';

  @override
  Loader get sourceLoader => PlainUrlLoader(base: base);

  String url(String path) => p.join(base, path);

  const ZipUrlLoader({required this.base}) : assert(base.length > 0);
}
