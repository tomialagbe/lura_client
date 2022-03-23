// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'package:flutter/widgets.dart';

void openLinkInNewWindow(BuildContext context, String link) {
  html.window.open(link, 'new tab');
}
