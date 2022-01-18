import 'dart:typed_data';
import 'dart:ui' as ui show Image;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets show Image;

import 'package:cross_file_manager/cross_file_manager.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'CrossFileManager Demo',
        home: Page(),
      );
}

class Page extends StatefulWidget {
  const Page({Key? key}) : super(key: key);

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  AssetCrossFileManager get fm => AssetCrossFileManager();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Priority File Detection')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...gettingString('String', 'assets/a/aim.json'),
            const Divider(),
            ...gettingImageWidget('Image', 'assets/a/elements/1/bird.webp'),
            const Divider(),
            ...gettingExists('Exists', 'assets/a/non_exists.file'),
            const Divider(),
            ...gettingExists('Exists', 'assets/a/aim.json'),
          ],
        ),
      );

  List<Widget> gettingString(String title, String path) =>
      view(title, path, fm.loadString(path));

  List<Widget> gettingImageWidget(String title, String path) =>
      view(title, path, fm.loadImageWidget(path, width: screenWidth / 3));

  List<Widget> gettingExists(String title, String path) =>
      view(title, path, fm.exists(path));

  List<Widget> view(String title, String path, dynamic data) => [
        Text(title, textScaleFactor: 2),
        Text(path),
        _buildFuture(data),
      ];

  Widget _buildFuture(Future<dynamic> future) => FutureBuilder<dynamic>(
      future: future,
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return Text(
            snapshot.error.toString(),
            style: const TextStyle(color: Colors.redAccent),
          );
        }

        return snapshot.hasData ? _buildData(snapshot.data!) : Container();
      });

  Widget _buildData(dynamic data) {
    if (data == null) {
      return const Text('NULL');
    }

    if (data is bool) {
      return Text(data ? 'YES' : 'NO');
    }

    if (data is ui.Image) {
      return _buildFuture(data.toByteData());
    }

    if (data is widgets.Image) {
      return data;
    }

    if (data is ByteData) {
      // \todo return Image.memory(data.buffer.asUint8List());
      throw UnimplementedError;
    }

    if (data is String) {
      return Text(data);
    }

    return Text('Unrecognized `$data`');
  }

  double get screenWidth => MediaQuery.of(context).size.width;
}
