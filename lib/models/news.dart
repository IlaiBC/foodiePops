class News {
  String author;
  String title;
  String description;
  String url;
  String picUrl;
  String date;

  News({this.author, this.title, this.description, this.url, this.date, this.picUrl});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      author: json['author'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      date: json['date'] as String,
      picUrl: json['picUrl'] as String
    );
  }
}