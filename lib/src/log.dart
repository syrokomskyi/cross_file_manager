/// The type of function for logging.
typedef Log = void Function(String);

/// The logging to console.
/// U+1F343
// ignore: avoid_print
void li(String s) => print('🍃 ${s.truncated}');

/// The fake logging.
void liSilent(String s) {}

/// How many symbols of 1 variable we will output then logging.
const _truncatedLength = 300;

extension _StringExtension on String {
  String get truncated => _truncatedLength >= length
      ? this
      : replaceRange(_truncatedLength, length, '…');
}
