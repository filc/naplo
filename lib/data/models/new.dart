class News {
  String title;
  String content;
  String image;
  String link;

  News(this.title, this.content, this.image, this.link);

  factory News.fromJson(Map json) {
    return News(json["title"], json["content"], json["image"], json["link"]);
  }
  // {
  //   "title": "Kedves felhasznalok!",
  //   "content": "Nagyon ugyesek vagytok nezzetek meg ezt a kurvajo videot. Kosz viszlat.",
  //   "image": "https://filcnaplo.hu/img/msg01.png",
  //   "link": "https://youtu.be/dQw4w9WgXcQ"
  // }

}
