import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

String generateUserId(String username, String instituteCode) =>
    md5.convert(utf8.encode(username + instituteCode)).toString();

String generateProfileId(String userId) => md5
    .convert(
      utf8.encode(
        userId + DateTime.now().millisecondsSinceEpoch.toString(),
      ),
    )
    .toString();

String getPlatform(context) {
  switch (Theme.of(context).platform) {
    case TargetPlatform.android:
      return "Android";
    case TargetPlatform.iOS:
      return "iOS";
    default:
      return "unknown";
  }
}
