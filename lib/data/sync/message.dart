import 'dart:convert';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/data/models/dummy.dart';

class MessageSync {
  List<Message> received = [];
  List<Message> sent = [];
  List<Message> archived = [];
  List<Message> drafted = [];

  
  
  Future<bool> sync() async {
    if (!app.debugUser) {
    
      Future<void> getMessages() async {
        List types = [
            "beerkezett",
            "elkuldott",
            "torolt",
          ];
        received = await app.user.kreta.getMessages(types[0]);
        sent = await app.user.kreta.getMessages(types[1]);
        archived = await app.user.kreta.getMessages(types[2]);
      }

      getMessages(); 
      bool success = (received != null && sent != null && archived != null);
      if (!success) {
        await app.user.kreta.refreshLogin();
        getMessages();
      }

      if (success) {

        List types = ["inbox", "sent", "trash", "draft"];
        for (int i = 0 ; i < 3 ; i++) { // Kitörli a lokálisan elmentett üzeneteket
          await app.user.storage.delete("messages_" + types[i]); 
        }

        void saveLocaly(List<Message> messages,String type) async { //Adott tipushoz elmenti adatbázisba a megadott üzeneteket
          await Future.forEach(messages, (message) async {
          if (message.json != null) {
            await app.user.storage.insert("messages_" + type, {
              "json": jsonEncode(message.json),
            });
          }
        });
        }

        saveLocaly(received, types[0]);
        saveLocaly(sent, types[1]);
        saveLocaly(archived, types[2]);
        
      }

      return success;
    } else {
      received = Dummy.messages;
      return true;
    }
  }

  delete() {
    received = [];
    sent = [];
    archived = [];
    drafted = [];
  }
}
