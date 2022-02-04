import '../loaders/plain_assets_loader.dart';
import '../loaders/zip_assets_loader.dart';
import 'cross_file_manager.dart';
import 'default_value_mix.dart';

/// \see /example/lib/main.dart
class AssetsCrossFileManager extends CrossFileManager with DefaultValueMix {
  static final _instance = AssetsCrossFileManager._();

  factory AssetsCrossFileManager() => _instance;

  AssetsCrossFileManager._()
      : super(
          loaders: const [
            PlainAssetsLoader(),
            ZipAssetsLoader(),
          ],
          needClearCache: false,
        );
}
