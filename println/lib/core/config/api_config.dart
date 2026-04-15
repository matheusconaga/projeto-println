import 'package:flutter/foundation.dart';
import 'dart:io';

class ApiConfig {

  static String get baseUrl {

    if (kIsWeb) {
      return "http://127.0.0.1:8000";
    }

    if (Platform.isAndroid) {
      return "http://192.168.1.104:8000";
    }

    return "http://127.0.0.1:8000";

  }

}