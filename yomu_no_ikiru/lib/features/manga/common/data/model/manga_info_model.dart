import 'dart:convert';

import 'package:yomu_no_ikiru/features/manga/common/domain/entities/manga_info.dart';

class MangaInfoModel extends MangaInfo {
  MangaInfoModel.empty() : super.empty();
  MangaInfoModel({
    required super.score,
    required super.rank,
    required super.popularity,
    required super.users,
    required super.members,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'score': score,
      'rank': rank,
      'popularity': popularity,
      'users': users,
      'members': members,
    };
  }

  factory MangaInfoModel.fromMap(Map<String, dynamic> map) {
    return MangaInfoModel(
      score: map['score'] as double,
      rank: map['rank'] as double,
      popularity: map['popularity'] as double,
      users: map['users'] as double,
      members: map['members'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory MangaInfoModel.fromJson(String source) =>
      MangaInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  MangaInfo copyWith({
    double? score,
    double? rank,
    double? popularity,
    double? users,
    double? members,
  }) {
    return MangaInfo(
      score: score ?? this.score,
      rank: rank ?? this.rank,
      popularity: popularity ?? this.popularity,
      users: users ?? this.users,
      members: members ?? this.members,
    );
  }
}
