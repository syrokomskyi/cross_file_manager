# CrossFileManager

Transparent reading of files wherever they are located: assets, Internet (by URL), zip archives.

## Features

You can choose with `Cross File Manager` the priority for uploaders yourself. For example, if the file is not in the assets, an attempt will be made to get the file from the cloud.

You can develop own loader for download files from Firebase, Firestore, Amazon AWS, Google Drive, Microsoft Azure Cloud Storage, OneDrive, Dropbox, etc. - any data source can be included in the CrossFileManager. See `class Loader` and [already implemented loaders](https://github.com/signmotion/cross_file_manager/tree/master/lib/src/loaders).

Can retrieve the needed file from an archive. It comes in handy when you need to download thousands of small files.

Can memorize a received file and retrieve it from local storage the next time it is requested.

Able to download files in formats:

- `String`
- `Image` like `dart.ui`
- `Image` like `package:flutter/widgets.dart`
- `File`, binary data

### How it works

#### Direct path to file

![Direct path to file - CrossFileManager](https://raw.githubusercontent.com/signmotion/cross_file_manager/master/images/direct_path_to_file.webp)

#### Direct path to file with cache

![Direct path to file with cache - CrossFileManager](https://raw.githubusercontent.com/signmotion/cross_file_manager/master/images/direct_path_to_file_with_cache.webp)

#### ZIP path to file

![ZIP path to file - CrossFileManager](https://raw.githubusercontent.com/signmotion/cross_file_manager/master/images/zip_path_to_file.webp)

## Getting started

Add this package to `pubspec.yaml`. See `Installing` tab above.

## Usage

Create a manager for App:

```dart
final fm = CrossFileManager.create(
  loaders: const [
    PlainAssetsLoader(),
    ZipAssetsLoader(),
    PlainFileLoader(),
    ZipFileLoader(),
  ],
);
```

Use the manager in the App:

```dart
final String? r = await fm.loadString(path);
```

```dart
import 'dart:ui' as ui;

final ui.Image? r = await fm.loadImageUi(path);
```

```dart
import 'package:flutter/widgets.dart' as widgets;

final widgets.Image? r = await fm.loadImageWidget(path);
```

```dart
final File? r = await fm.loadFile(path);
```

```dart
final bool r = await fm.exists(path);
```

```dart
final bool r = await fm.existsInCache(path);
```

```dart
/// Just add file to cache for fast access in the future.
await fm.warmUp(path);
```

The manager announced above will search file by `path` in the local assets,
then in the zip archives of local assets,
then in the local filesystem,
then in the zip archives of local filesystem.

It will return the first file found.

See `example/main.dart` for more use cases:

[![Example App with CrossFileManager](https://raw.githubusercontent.com/signmotion/cross_file_manager/master/images/zip_assets_demo.webp)](https://github.com/signmotion/cross_file_manager/tree/master/example)

## TODO

- Separate the package to work with pure Dart.
- ? Replace `File` to `XFile`. <https://pub.dev/packages/cross_file>
