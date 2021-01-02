import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/config.dart';
//import 'package:filcnaplo/data/models/dummy.dart';

class ConfigSync {
  Config data = Config.defaults;

  Future<bool> sync() async {
    if (!app.debugUser) {
      Config config;
      config = await app.kretaApi.client.getConfig();

      if (config != null) {
        data = config;

        await app.storage.storage.update("settings", {
          "config": jsonEncode(config.json),
        });
      }

      return config != null;
    } else {
      return true;
    }
  }

  delete() {
    data = Config.defaults;
  }
}
