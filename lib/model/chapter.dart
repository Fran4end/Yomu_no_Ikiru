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

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(date: json['date'], title: json['title'], link: json['link']);
  }
  // volume = json['volume'],
  // cover = json['cover'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'link': link,
        'date': date,
      };
}
