import 'package:flutter/foundation.dart';

import 'loader.dart';
import 'plain_firebase_loader.dart';
import 'zip_loader.dart';

/// The loader for load and trasform data from ZIP-archives from Firebase.
/// \warning Some files from ultra compression tools (for ex., 7Zip)
/// doesn't extract correctly.
class ZipFirebaseLoader extends ZipLoader {
  const ZipFirebaseLoader();

  @override
  @mustCallSuper
  String get temporaryFolder => '${super.temporaryFolder}/zf';

  @override
  Loader get sourceLoader => const PlainFirebaseLoader();
}
