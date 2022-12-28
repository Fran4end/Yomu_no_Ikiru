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

  set volumeCopertina(List value) {}

  Chapter.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        link = json['link'],
        date = json['date'],
        volume = json['volume'],
        copertina = json['copertina'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'link': link,
        'date': date,
      };
}
