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
  AppCrossFileManager get fm => AppCrossFileManager();

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
              ...plainAssetsDemo,
              ...zipAssetsDemo,
              ...urlDemo,
            ]..removeAt(0),
          ),
        ),
      );

  /// Get from local assets.
  /// \see [AppCrossFileManager] with [PlainAssetsLoader]
  List<Widget> get plainAssetsDemo => [
        ...subtitle('plain assets path'),
        ...getting(),
      ];

  /// Extract from zip-files.
  /// \see [AppCrossFileManager] with [ZipAssetsLoader]
  List<Widget> get zipAssetsDemo => [
        ...subtitle('zip assets path'),
        ...getting(archive: '2'),
      ];

  /// Download from Internet.
  /// \see [AppCrossFileManager] with [UrlLoader]
  List<Widget> get urlDemo => [
        ...subtitle('url plain path'),
        ...getting(),
      ];

  List<Widget> subtitle(String text) => [
        Padding(padding: EdgeInsets.all(appMagicSize / 2)),
        Text(text, textScaleFactor: 2),
        subtitleDivider,
      ];

  List<Widget> getting({String archive = ''}) => [
        ...gettingString('string', 'assets/1/owl/owl.json', archive: archive),
        ...gettingImageWidget('webp', 'assets/1/bird.webp', archive: archive),
        ...gettingImageWidget('png', 'assets/1/fox.png', archive: archive),
        ...gettingImageWidget('jpg', 'assets/1/whale.jpg', archive: archive),
        ...gettingExists('exists', 'assets/1/non_exists.txt', archive: archive),
        ...gettingExists('exists', 'assets/1/owl/owl.json', archive: archive),
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
        fm.loadImageWidget(path, width: appMagicSize),
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

        if (snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.all(appMagicSize / 10),
            child: _buildData(snapshot.data!),
          );
        }

        return Container();
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

  double get appMagicSize => screenWidth / 5;

  Widget get subtitleDivider => cellDivider;

  Widget get cellDivider => Divider(
        height: appMagicSize / 2,
        indent: appMagicSize,
        endIndent: appMagicSize,
      );
}

class AppCrossFileManager extends CrossFileManager {
  static const url =
      'https://raw.githubusercontent.com/signmotion/cross_file_manager/master/example/';

  static final AppCrossFileManager _instance = AppCrossFileManager._();

  factory AppCrossFileManager() {
    return _instance;
  }

  AppCrossFileManager._()
      : super(loaders: const [
          PlainAssetsLoader(),
          ZipAssetsLoader(),
          UrlLoader(base: url),
        ]);
}
