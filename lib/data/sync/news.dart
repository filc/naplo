import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/new.dart';

class NewsSync {
  List<News> data = [];
  List<News> fresh = []; // News to show with popup
  int length = 0;
  int prevLength = 0;

  Future<bool> sync() async {
    prevLength = (await app.storage.storage.query("settings"))[0]["news_len"];
    data = await app.user.kreta.getNews();
    fresh = [];

    length = data.length;
    if (length > prevLength) {
      int lag = (length - prevLength).clamp(0, 3);

      while (lag > 0) {
        // Add the missed news to list
        fresh.add(data[lag - 1]);
        lag--;
      }
      // print(fresh.map((e) => e.title));
    }

    await app.storage.storage.update("settings", {"news_len": length});
    return true;
  }

  void delete() {
    data = [];
  }
}
