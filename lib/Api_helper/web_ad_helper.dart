// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

Widget adsenseAdsView() {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
      'adViewType',
          (int viewID) => IFrameElement()
        ..width = '500'
        ..height = '500'
        ..src = 'adview.html'
        ..style.border = 'none');

  return const SizedBox(
    height: 500,
    width: 500.0,
    child: HtmlElementView(
      viewType: 'adViewType',
    ),
  );
}
