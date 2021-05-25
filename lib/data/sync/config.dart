import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/config.dart';
//import 'package:filcnaplo/data/models/dummy.dart';

class ConfigSync {
  Config config = Config.defaults;

  Future<bool> sync() async {
    if (!app.debugUser) {
      config = await app.kretaApi.client.getConfig();

      await app.storage.storage.update("settings", {
        "config": jsonEncode(config.json),
      });

      return true;
    } else {
      return true;
    }
  }

  delete() {
    config = Config.defaults;
  }
}
