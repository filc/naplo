import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/news.dart';

class NewsSync {
  List<News> news = [];
  List<News> fresh = []; // News to show with popup
  int length = 0;
  int prevLength = 0;

  Future sync() async {
    prevLength =
        (await app.storage.storage.query("settings"))[0]["news_len"] as int? ??
            0;
    news = await app.user.kreta.getNews();
    fresh = [];

    length = news.length;
    if (length > prevLength) {
      int lag = (length - prevLength).clamp(0, 3);

      while (lag > 0) {
        // Add the missed news to list
        fresh.add(news[lag - 1]);
        lag--;
      }
    }

    await app.storage.storage.update("settings", {"news_len": length});
  }

  void delete() {
    news = [];
  }
}
