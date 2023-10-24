class Chapter {
  final String id;
  final String? date;
  final String? cover;
  final String title;
  final int? volume;
  final String? link;
  final double? order;

  Chapter({
    required this.id,
    required this.date,
    required this.title,
    required this.link,
    this.cover,
    this.volume,
    this.order,
  });

  set volumeCover(List value) {}

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      date: json['date'],
      title: json['title'],
      link: json['link'],
      id: json['id'],
      volume: json["volume"],
      cover: json["cover"],
      order: json["order"],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'link': link,
        'date': date,
        'volume': volume,
        'cover': cover,
        'order': order,
      };

  @override
  String toString() {
    return "[$id --> ($title, $link)\n$date\n$volume, $cover] \n\n";
  }
}
