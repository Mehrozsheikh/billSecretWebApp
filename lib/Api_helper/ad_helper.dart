import 'dart:io';

import 'package:flutter/foundation.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return kDebugMode
          ? "ca-app-pub-3940256099942544/6300978111"
          : "ca-app-pub-7427017762238849/5293122180";
    } else if (Platform.isIOS) {
      return kDebugMode
          ? "ca-app-pub-3940256099942544/2934735716"
          : "ca-app-pub-7427017762238849/4438672680";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
