import 'package:cross_file_manager/cross_file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'CrossFileManager Demo',
        home: Page(),
        debugShowCheckedModeBanner: false,
      );
}

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  late final CrossFileManager fm;

  @override
  Widget build(BuildContext context) => FutureBuilder<CrossFileManager>(
        future: assetsCrossFileManager,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            fm = snapshot.data!;
            return _build();
          }

          return Container();
        },
      );

  Widget _build() => Scaffold(
        appBar: AppBar(title: const Text('Priority File Detection')),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...plainAssetsDemo,
              ...zipAssetsDemo,
              ...plainUrlDemo,
              ...zipUrlDemo,
            ]..removeAt(0),
          ),
        ),
      );

  /// Get from local assets.
  /// \see [appCrossFileManager] with [PlainAssetsLoader]
  List<Widget> get plainAssetsDemo => [
        ...subtitle('plain assets path'),
        ...gettingPlain(),
      ];

  /// Extract from zip-files.
  /// \see [appCrossFileManager] with [ZipAssetsLoader]
  List<Widget> get zipAssetsDemo => [
        ...subtitle('zip assets path'),
        ...gettingArchive('2'),
      ];

  /// Download from Internet.
  /// \see [appCrossFileManager] with [PlainUrlLoader]
  List<Widget> get plainUrlDemo => [
        ...subtitle('plain url path'),
        ...gettingPlain(),
      ];

  /// Download from Internet a preferred zip-file and extract requested file from it.
  /// \see [appCrossFileManager] with [ZipUrlLoader]
  List<Widget> get zipUrlDemo => [
        ...subtitle('zip url path'),
        ...gettingArchive('2', loaders: const [ZipUrlLoader(base: url)]),
      ];

  List<Widget> subtitle(String text) => [
        Padding(padding: EdgeInsets.all(appMagicSize / 2)),
        Text(text, textScaler: const TextScaler.linear(2)),
        subtitleDivider,
      ];

  List<Widget> gettingPlain() => [
        ...gettingString('string', 'assets/1/owl/owl.json'),
        ...gettingImageWidget('webp', 'assets/1/bird.webp'),
        ...gettingImageWidget('png', 'assets/1/fox.png'),
        ...gettingImageWidget('jpg', 'assets/1/whale.jpg'),
        ...gettingExists('exists', 'assets/1/absent.txt'),
        ...gettingExists('exists', 'assets/1/owl/owl.json'),
      ];

  List<Widget> gettingArchive(String name, {List<Loader>? loaders}) => [
        ...gettingString(
          'string',
          'assets/$name/owl/owl.json',
          archive: name,
          loaders: loaders,
        ),
        ...gettingImageWidget(
          'webp',
          'assets/$name/bird.webp',
          archive: name,
          loaders: loaders,
        ),
        ...gettingImageWidget(
          'png',
          'assets/$name/fox.png',
          archive: name,
          loaders: loaders,
        ),
        ...gettingImageWidget(
          'jpg',
          'assets/$name/whale.jpg',
          archive: name,
          loaders: loaders,
        ),
        ...gettingExists(
          'exists',
          'assets/$name/absent.txt',
          archive: name,
          loaders: loaders,
        ),
        ...gettingExists(
          'exists',
          'assets/$name/owl/owl.json',
          archive: name,
          loaders: loaders,
        ),
      ];

  List<Widget> gettingString(
    String title,
    String path, {
    String archive = '',
    List<Loader>? loaders,
  }) =>
      view(
        title,
        path,
        fm.loadStringOrDefault(path, loaders: loaders, def: 'NOT FOUND'),
        archive: archive,
      );

  List<Widget> gettingImageWidget(
    String title,
    String path, {
    String archive = '',
    List<Loader>? loaders,
  }) =>
      view(
        title,
        path,
        fm.loadImageWidgetOrDefault(
          path,
          width: appMagicSize,
          loaders: loaders,
        ),
        archive: archive,
      );

  List<Widget> gettingExists(
    String title,
    String path, {
    String archive = '',
    List<Loader>? loaders,
  }) =>
      view(
        title,
        path,
        fm.exists(path, loaders: loaders),
        archive: archive,
      );

  List<Widget> view(
    String title,
    String path,
    Future<dynamic> data, {
    String archive = '',
  }) =>
      [
        Text(title, textScaler: const TextScaler.linear(1.5)),
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

    if (data is String) {
      return Text(data);
    }

    if (data is widgets.Widget) {
      return data;
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

const url =
    'https://raw.githubusercontent.com/signmotion/cross_file_manager/master/example/';

/// \see [AssetsCrossFileManager] for singleton implementation.
final appCrossFileManager = CrossFileManager.create(
  loaders: const [
    PlainAssetsLoader(),
    ZipAssetsLoader(),
    PlainUrlLoader(base: url),

    /// \see [zipUrlDemo]
    // ZipUrlLoader(base: url),
  ],
  needClearCache: true,
);
