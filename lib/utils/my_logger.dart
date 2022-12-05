import 'package:logger/logger.dart';

abstract class MyLogger {
  static print(message) {
    final log = Logger();
    log.d(message);
  }
}
