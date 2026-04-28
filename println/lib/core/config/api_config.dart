import 'package:flutter/foundation.dart';
import 'dart:io';

class ApiConfig {
  static const String productionUrl =
      "https://println-api.onrender.com";

  static String get baseUrl {
    if (kReleaseMode) {
      return productionUrl;
    }

    if (kIsWeb) {
      return "http://localhost:8000";
    }

    if (Platform.isAndroid) {
      return "http://10.0.2.2:8000";
    }

    return "http://127.0.0.1:8000";
  }
}