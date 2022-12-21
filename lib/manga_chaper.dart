class Chapter {
  final String? date;
  final String? copertina;
  final String title;
  final int? volume;
  final String? link;

  Chapter({
    required this.date,
    required this.title,
    required this.link,
    this.copertina,
    this.volume,
  });
}
