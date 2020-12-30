import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/new.dart';

class NewSync {
  List<News> data = [];
  int lenght = 0;
  Future<void> sync() async {
    data = await app.user.kreta.getNews();

    // mentsd el hosszat

    // popup ??
  }

  void delete() {
    data = [];
  }
}
