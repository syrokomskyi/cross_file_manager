import 'dart:ui' as ui;

import 'package:flutter/material.dart' hide Image;

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Table(
          columnWidths: const <int, TableColumnWidth>{
            0: IntrinsicColumnWidth(),
            1: IntrinsicColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            const TableRow(
              children: <Widget>[
                Text('Path in assets'),
                Text(''),
              ],
            ),
            gettingFrom('assets/a/aim.json'),
            gettingFrom('assets/a/non_exists.file'),
            gettingFrom('assets/elements/1/bird.webp'),
          ],
        ),
      ),
    );
  }

  TableRow gettingFrom(String path) {
    final fm = AssetCrossFileManager();

    final exists = fm.exists(path);

    return TableRow(
      children: <Widget>[
        Text(path),
        _buildFuture(exists),
      ],
    );
  }

  Widget _buildFuture(Future<dynamic> future) => FutureBuilder<dynamic>(
        future: future,
        builder: (_, snapshot) =>
            snapshot.hasData ? _buildData(snapshot.data!) : Container(),
      );

  Widget _buildData(dynamic data) {
    if (data is bool) {
      return Text(data ? 'OK' : '-', textAlign: TextAlign.center);
    }

    if (data is ui.Image) {
      //return ui.Image.memory(image: data);
    }

    return const Text('UNDEFINED', textAlign: TextAlign.center);
  }
}
