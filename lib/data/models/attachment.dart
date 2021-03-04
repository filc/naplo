import 'package:file_picker/file_picker.dart';

class Attachment {
  int id;
  PlatformFile file;
  String name;
  String fileId;
  Map json;
  String kretaFilePath;

  Attachment(
    this.id,
    this.file,
    this.name,
    this.fileId,
    this.kretaFilePath, {
    this.json,
  });

  factory Attachment.fromJson(Map json) {
    int id = json["azonosito"];
    PlatformFile file;
    String name = json["fajlNev"];
    String fileId;
    String kretaFilePath = json["utvonal"] ?? "";

    return Attachment(
      id,
      file,
      name,
      fileId,
      kretaFilePath,
      json: json,
    );
  }
}
