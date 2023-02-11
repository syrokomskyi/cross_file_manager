import 'package:flutter/foundation.dart';

import 'loader.dart';
import 'plain_assets_loader.dart';
import 'zip_loader.dart';

/// The loader for load and trasform data from ZIP-archives from assets.
/// \warning Some files from ultra compression tools (for ex., 7Zip)
/// doesn't extract correctly.
class ZipAssetsLoader extends ZipLoader {
  @override
  @mustCallSuper
  String get temporaryFolder => '${super.temporaryFolder}/za';

  @override
  Loader get sourceLoader => const PlainAssetsLoader();

  const ZipAssetsLoader();
}
