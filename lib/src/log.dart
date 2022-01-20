import 'cross_file_manager.dart';

void log(String s) {
  if (CrossFileManager.log) {
    print(s);
  }
}
