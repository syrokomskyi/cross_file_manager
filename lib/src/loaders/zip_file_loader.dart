import 'package:flutter/foundation.dart';

import 'loader.dart';
import 'plain_file_loader.dart';
import 'zip_loader.dart';

/// The loader for load and trasform data from ZIP-archives from file system.
/// \warning Some files from ultra compression tools (for ex., 7Zip)
/// doesn't extract correctly.
class ZipFileLoader extends ZipLoader {
  @override
  @mustCallSuper
  String get temporaryFolder => '${super.temporaryFolder}/zf';

  @override
  Loader get sourceLoader => const PlainFileLoader();

  const ZipFileLoader();
}
