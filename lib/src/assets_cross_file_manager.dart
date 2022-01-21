import 'cross_file_manager.dart';
import 'default_value_mix.dart';
import 'plain_assets_loader.dart';
import 'zip_assets_loader.dart';

/// \see /example/lib/main.dart
class AssetsCrossFileManager extends CrossFileManager with DefaultValueMix {
  static final _instance = AssetsCrossFileManager._();

  factory AssetsCrossFileManager() {
    return _instance;
  }

  AssetsCrossFileManager._()
      : super(loaders: const [
          PlainAssetsLoader(),
          ZipAssetsLoader(),
        ]);
}
