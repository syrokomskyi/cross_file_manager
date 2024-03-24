# Cross File Manager

![Cover - Cross File Manager](https://raw.githubusercontent.com/signmotion/cross_file_manager/master/images/cover.webp)

[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Pub Package](https://img.shields.io/badge/doc-cross_file_manager-blue)](https://pub.dartlang.org/packages/cross_file_manager)
[![Build Status](https://github.com/signmotion/cross_file_manager/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/signmotion/cross_file_manager/actions/workflows/flutter-ci.yml)
[![Publisher](https://img.shields.io/pub/publisher/cross_file_manager)](https://pub.dev/publishers/syrokomskyi.com)

Transparent reading of files from Flutter assets, Internet (by URL), zip archives by uploader priority.
The easy-to-use package.
Feel free to use it in your awesome project.

## Features

We can choose with `CrossFileManager` the priority for uploaders yourself. For example, if the file is not in the assets, an attempt will be made to get the file from the cloud.

Can develop own loader for download files from Firebase, Firestore, Amazon AWS, Google Drive, Microsoft Azure Cloud Storage, OneDrive, Dropbox, etc. - any data source can be included in the CrossFileManager. See `class Loader` and [already implemented loaders](https://github.com/signmotion/cross_file_manager/tree/master/lib/src/loaders).

Can retrieve the needed file from an archive. It comes in handy when you need to download thousands of small files.

Can memorize a received file and retrieve it from local storage the next time it is requested.

Able to download files in formats:

- `String`
- `Image` like `dart.ui`
- `Image` like `package:flutter/widgets.dart`
- `File`, binary data

### How it works

![Direct path to file - CrossFileManager](https://raw.githubusercontent.com/signmotion/cross_file_manager/master/images/request_response.webp)

## Usage

### Create a Manager for App

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

### Use the Manager in App

```dart
final r = await fm.loadString(path);
```

```dart
final r = await fm.loadFile(path);
```

```dart
final r = await fm.loadImageUi(path);
```

```dart
final r = await fm.loadImageWidget(path);
```

```dart
final r = await fm.exists(path);
```

```dart
final r = await fm.existsInCache(path);
```

```dart
// Just add a file to cache for fast access in the future.
await fm.warmUp(path);
```

The manager announced above will search file by `path` in the local assets,
then in the zip archives of local assets,
then in the local filesystem,
then in the zip archives of local filesystem.

It will return the first file found.

See `example/main.dart` for more use cases:

[![Example App with CrossFileManager](https://raw.githubusercontent.com/signmotion/cross_file_manager/master/images/zip_assets_demo.webp)](https://github.com/signmotion/cross_file_manager/tree/master/example)

## Welcome

Requests and suggestions are warmly welcome.

This package is open-source, stable and well-tested. Development happens on
[GitHub](https://github.com/signmotion/cross_file_manager). Feel free to report issues
or create a pull-request there.

General questions are best asked on
[StackOverflow](https://stackoverflow.com/questions/tagged/cross_file_manager).

## TODO

- Separate the package to work with pure Dart.
- Replace `File` to `WFile`. <https://pub.dev/packages/wfile>
- Change chunks of code for transform images to [flutter_image_converter](https://pub.dartlang.org/packages/flutter_image_converter).
