import 'dart:convert';

Map<String, dynamic> parseJwt(String token) {
  if (token == null) return null;

  final parts = token.split('.');
  if (parts.length != 3) return null;

  final payload = parts[1];
  var normalized = base64Url.normalize(payload);
  var resp = utf8.decode(base64Url.decode(normalized));
  final payloadMap = json.decode(resp);

  if (payloadMap is! Map<String, dynamic>) {
    return null;
  }

  return payloadMap;
}
