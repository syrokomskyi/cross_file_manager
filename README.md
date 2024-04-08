# Cross File Manager

![Cover - Cross File Manager](https://raw.githubusercontent.com/signmotion/cross_file_manager/master/images/cover.webp)

[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Pub Package](https://img.shields.io/pub/v/id_gen.svg?logo=dart&logoColor=00b9fc&color=blue)](https://pub.dartlang.org/packages/id_gen)
[![Code Size](https://img.shields.io/github/languages/code-size/signmotion/id_gen?logo=github&logoColor=white)](https://github.com/signmotion/id_gen)
[![Publisher](https://img.shields.io/pub/publisher/id_gen)](https://pub.dev/publishers/syrokomskyi.com)

![SDK version](https://badgen.net/pub/sdk-version/id_gen)
![Supported platforms](https://badgen.net/pub/flutter-platform/id_gen)
![Supported SDKs](https://badgen.net/pub/dart-platform/id_gen)

[![Build Status](https://img.shields.io/github/actions/workflow/status/signmotion/id_gen/dart-ci.yml?logo=github-actions&logoColor=white)](https://github.com/signmotion/id_gen/actions)
[![Pull Requests](https://img.shields.io/github/issues-pr/signmotion/id_gen?logo=github&logoColor=white)](https://github.com/signmotion/id_gen/pulls)
[![Issues](https://img.shields.io/github/issues/signmotion/id_gen?logo=github&logoColor=white)](https://github.com/signmotion/id_gen/issues)
[![Pub Score](https://img.shields.io/pub/points/id_gen?logo=dart&logoColor=00b9fc)](https://pub.dev/packages/id_gen/score)

Transparent reading of files from Flutter assets, Internet (by URL), zip archives by uploader priority.
The easy-to-use package.
Feel free to use it in your awesome project.

## Features

We can choose with **CrossFileManager** the priority for uploaders yourself. For example, if the file is not in the assets, an attempt will be made to get the file from the cloud.

Can develop own loader for download files from Firebase, Firestore, Amazon AWS, Google Drive, Microsoft Azure Cloud Storage, OneDrive, Dropbox, etc. - any data source can be included in the CrossFileManager. See `class Loader` and [already implemented loaders](https://github.com/signmotion/cross_file_manager/tree/master/lib/src/loaders).

Can retrieve the needed file from an archive. It comes in handy when you need to download thousands of small files.

Can memorize a received file and retrieve it from local storage the next time it is requested.

Able to download files in formats:

- `String`
- `Image` like `dart.ui`
- `Image` like `package:flutter/widgets.dart`
- `File`, binary data

### How it works

[<img src="https://raw.githubusercontent.com/signmotion/cross_file_manager/master/images/request_response.webp" width="600"/>](https://raw.githubusercontent.com/signmotion/cross_file_manager/master/images/request_response.webp)

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

[<img src="https://raw.githubusercontent.com/signmotion/cross_file_manager/master/images/screenshots/zip_assets_demo.webp" width="600"/>](https://github.com/signmotion/cross_file_manager/tree/master/example)

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

Created [with ❤️](https://syrokomskyi.com)
