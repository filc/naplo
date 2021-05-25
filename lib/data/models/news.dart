class News {
  String? title;
  String? content;
  String? image;
  String? link;

  News(this.title, this.content, this.image, this.link);

  factory News.fromJson(Map json) {
    return News(json["title"], json["content"], json["image"], json["link"]);
  }
}