import 'dart:convert';

import 'package:yomu_no_ikiru/features/manga/common/domain/entities/chapter.dart';

class ChapterModel extends Chapter {
  ChapterModel({
    required super.id,
    required super.date,
    required super.cover,
    required super.title,
    required super.volume,
    required super.link,
    required super.order,
  });

  ChapterModel copyWith({
    String? id,
    DateTime? date,
    String? cover,
    String? title,
    int? volume,
    String? link,
    int? order,
  }) {
    return ChapterModel(
      id: id ?? this.id,
      date: date ?? this.date,
      cover: cover ?? this.cover,
      title: title ?? this.title,
      volume: volume ?? this.volume,
      link: link ?? this.link,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'cover': cover,
      'title': title,
      'volume': volume,
      'link': link,
      'order': order,
    };
  }

  factory ChapterModel.fromMap(Map<String, dynamic> map) {
    return ChapterModel(
      id: map['id'] as String,
      date: map['date'] as DateTime,
      cover: map['cover'] as String,
      title: map['title'] as String,
      volume: map['volume'] as int,
      link: map['link'] as String,
      order: map['order'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChapterModel.fromJson(String source) =>
      ChapterModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
