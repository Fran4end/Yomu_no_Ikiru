class Chapter {
  final String? date;
  final String? cover;
  final String title;
  final int? volume;
  final String? link;

  Chapter({
    required this.date,
    required this.title,
    required this.link,
    this.cover,
    this.volume,
  });

  set volumeCover(List value) {}

  Chapter.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        link = json['link'],
        date = json['date'],
        volume = json['volume'],
        cover = json['cover'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'link': link,
        'date': date,
      };
}
