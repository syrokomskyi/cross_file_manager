typedef Log = void Function(String);

/// U+1F343
void li(String s) => print('🍃 ${s.truncated}');

void liSilent(String s) {}

const _truncatedLength = 300;

extension _StringExtension on String {
  String get truncated => _truncatedLength >= length
      ? this
      : replaceRange(_truncatedLength, length, '…');
}
