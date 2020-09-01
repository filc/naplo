import 'package:crypto/crypto.dart';
import 'dart:convert';

String generateUserId(String username, String instituteCode) =>
    md5.convert(utf8.encode(username + instituteCode)).toString();

String generateProfileId(String userId) => md5
    .convert(
      utf8.encode(
        userId + DateTime.now().millisecondsSinceEpoch.toString(),
      ),
    )
    .toString();
