class Chapter {
  final int number;
  final String data;
  final String? copertina;
  final String? title;

  Chapter({
    required this.number,
    required this.data,
    this.title,
    this.copertina,
  });
}
