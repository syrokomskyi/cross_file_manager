import 'cross_file_manager.dart';
import 'plain_assets_loader.dart';
import 'zip_assets_loader.dart';

class AssetCrossFileManager extends CrossFileManager {
  static final AssetCrossFileManager _instance = AssetCrossFileManager._();

  factory AssetCrossFileManager() {
    return _instance;
  }

  AssetCrossFileManager._()
      : super(loaders: const [
          PlainAssetsLoader(),
          ZipAssetsLoader(),
        ]);
}
