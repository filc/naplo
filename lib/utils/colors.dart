import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:crypto/crypto.dart';
//import 'package:filcnaplo/ui/theme.dart';

Color textColor(Color color) {
  return color.computeLuminance() >= 0.5 ? Colors.black : Colors.white;
}

Color stringToColor(String str) {
  int hash = 0;

  str = md5.convert(utf8.encode(str)).toString();

  for (int i = 0; i < str.length; i++) {
    hash = str.codeUnitAt(i) + ((hash << 5) - hash);
  }

  String color = '#';

  for (int i = 0; i < 3; i++) {
    var value = (hash >> (i * 8)) & 0xFF;
    color += value.toRadixString(16);
  }

  color += "000000";
  color = color.substring(0, 7);

  return TinyColor.fromString(color).color;
}

Brightness invertBrightness(Brightness brightness) {
  return brightness == Brightness.light ? Brightness.dark : Brightness.light;
}
