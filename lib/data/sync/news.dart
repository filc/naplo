import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/new.dart';

class NewsSync {
  List<News> data = [];
  List<News> fresh = []; // News to show with popup
  int lenght;
  int prevLength;
  Future<void> sync() async {
    prevLength = (await app.storage.storage.query("settings"))[0]["news_len"];
    data = await app.user.kreta.getNews();

    lenght = data.length;
    if (lenght > prevLength) {
      int lag = lenght - prevLength;
      if (lag > 3) lag = 3;

      print("lag: " + lag.toString());
      while (lag > 0) {
        // Add the missed news to list
        fresh.add(data[lag - 1]);
        lag--;
      }
      print(fresh.map((e) => e.title));
    }

    await app.storage.storage.update("settings", {"news_len": lenght});
  }

  void delete() {
    data = [];
  }
}
