class Chapter {
  final String id;
  final DateTime date;
  final String cover;
  final String title;
  final int volume;
  final String link;
  final int order;

  Chapter({
    required this.id,
    required this.date,
    required this.cover,
    required this.title,
    required this.volume,
    required this.link,
    required this.order,
  });

  @override
  String toString() {
    return 'Chapter(id: $id, date: $date, cover: $cover, title: $title, volume: $volume, link: $link, order: $order)';
  }
}
