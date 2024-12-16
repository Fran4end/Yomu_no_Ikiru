class MangaInfo {
  final double score;
  final double rank;
  final double popularity;
  final double users;
  final double members;

  MangaInfo.empty()
      : score = 0.0,
        rank = 0.0,
        popularity = 0.0,
        users = 0.0,
        members = 0.0;
  MangaInfo({
    required this.score,
    required this.rank,
    required this.popularity,
    required this.users,
    required this.members,
  });

  @override
  String toString() {
    return 'MangaInfo(score: $score, rank: $rank, popularity: $popularity, users: $users, members: $members)';
  }
}
