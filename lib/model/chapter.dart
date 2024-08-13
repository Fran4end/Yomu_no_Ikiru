import 'package:intl/intl.dart';

class Chapter {
  final String id;
  final DateTime date;
  final String? cover;
  final String title;
  final int? volume;
  final String link;
  final double? order;
  int? nPages;

  Chapter({
    required this.id,
    required this.date,
    required this.title,
    required this.link,
    this.nPages,
    this.cover,
    this.volume,
    this.order,
  });

  set volumeCover(List value) {}

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      date: DateFormat().parse(json['date'].toString().trim()),
      title: json['title'],
      link: json['link'],
      id: json['id'],
      nPages: json['nPages'] ?? 0,
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
        'nPages': nPages,
        'volume': volume,
        'cover': cover,
        'order': order,
      };

  @override
  String toString() {
    return "[$id --> ($title, $link)\n$nPages\n$date\n$volume, $cover] \n\n";
  }
}
