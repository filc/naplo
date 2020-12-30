import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/pages/news/tile.dart';

class NewsBuilder {
  List<NewsTile> newsTiles = [];

  NewsBuilder();

  void build() {
    newsTiles = [];

    app.user.sync.news.data.forEach((news) => newsTiles.add(NewsTile(news)));
  }
}
