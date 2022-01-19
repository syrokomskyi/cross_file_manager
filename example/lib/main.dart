import 'package:cross_file_manager/cross_file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets show Image;

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
  void initState() {
    super.initState();

    fm.clearCache();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Priority File Detection')),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...plainPathDemo,
              ...zipPathDemo,
            ],
          ),
        ),
      );

  List<Widget> get plainPathDemo => [
        ...subtitle('plain path'),
        ...gettingString('string', 'assets/1/owl/owl.json'),
        ...gettingImageWidget('webp', 'assets/1/bird.webp'),
        ...gettingImageWidget('png', 'assets/1/fox.png'),
        ...gettingImageWidget('jpg', 'assets/1/whale.jpg'),
        ...gettingExists('exists', 'assets/1/non_exists.file'),
        ...gettingExists('exists', 'assets/1/owl/owl.json'),
      ]..removeLast();

  /// Extract from zip-files.
  List<Widget> get zipPathDemo => [
        ...subtitle('zip path'),
        ...gettingString('string', 'assets/2/owl/owl.json', archive: '2'),
        ...gettingImageWidget('webp', 'assets/2/bird.webp', archive: '2'),
        ...gettingImageWidget('png', 'assets/2/fox.png', archive: '2'),
        ...gettingImageWidget('jpg', 'assets/2/whale.jpg', archive: '2'),
        ...gettingExists('exists', 'assets/2/non_exists.file', archive: '2'),
        ...gettingExists('exists', 'assets/2/owl/owl.json', archive: '2'),
      ]..removeLast();

  List<Widget> subtitle(String text) => [
        subtitleDivider,
        Text(text, textScaleFactor: 2),
        subtitleDivider,
      ];

  List<Widget> gettingString(
    String title,
    String path, {
    String archive = '',
  }) =>
      view(
        title,
        path,
        fm.loadString(path),
        archive: archive,
      );

  List<Widget> gettingImageWidget(
    String title,
    String path, {
    String archive = '',
  }) =>
      view(
        title,
        path,
        fm.loadImageWidget(path, width: screenWidth / 3),
        archive: archive,
      );

  List<Widget> gettingExists(
    String title,
    String path, {
    String archive = '',
  }) =>
      view(
        title,
        path,
        fm.exists(path),
        archive: archive,
      );

  List<Widget> view(
    String title,
    String path,
    dynamic data, {
    String archive = '',
  }) =>
      [
        Text(title, textScaleFactor: 1.5),
        Text(archive.isEmpty
            ? path
            : path.replaceFirst(archive, '$archive.zip')),
        _buildFuture(data),
        cellDivider,
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

    if (data is widgets.Image) {
      return data;
    }

    if (data is String) {
      return Text(data);
    }

    return Text('Unrecognized `$data`');
  }

  double get screenWidth => MediaQuery.of(context).size.width;

  static const Widget subtitleDivider =
      Divider(height: 30, color: Colors.black);

  static const Widget cellDivider = Divider();
}
