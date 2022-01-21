import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;

import 'cross_file_manager.dart';
import 'loader.dart';

mixin DefaultValueMix on CrossFileManager {
  static const defImageWidget = Icon(Icons.image, color: Colors.indigoAccent);
  static const defString = '';

  Future<widgets.Widget> loadImageWidgetOrDefault(
    String path, {
    List<Loader>? loaders,
    double? width,
    double? height,
    widgets.BoxFit? fit,
    widgets.Image? def,
  }) async =>
      await loadImageWidget(
        path,
        loaders: loaders,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stack) => def ?? defImageWidget,
      ) ??
      def ??
      defImageWidget;

  Future<String> loadStringOrDefault(
    String path, {
    List<Loader>? loaders,
    String? def,
  }) async =>
      await loadString(path, loaders: loaders) ?? def ?? defString;
}
