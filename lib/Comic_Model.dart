class ComicModel {
  String title;
  String month;
  String day;
  int num;
  String link;
  String year;
  String news;
  String safe_title;
  String transcript;
  String alt;
  String img;

  ComicModel({this.title, this.month, this.day, this.num, this.link, this.year, this.news, this.safe_title, this.transcript, this.alt, this.img});

  factory ComicModel.fromJson(Map<String, dynamic> json) {
    return ComicModel(
        title: json["title"],
        month: json["month"],
        day: json["day"],
        num: json["num"],
        link: json["link"],
        year: json["year"],
        news: json["news"],
        safe_title: json["safe_title"],
        transcript: json["transcript"],
        alt: json["alt"],
        img: json["img"]
    );
  }
}
