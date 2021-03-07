import 'package:flutter/foundation.dart';

import 'gallery_comment_span.dart';

@immutable
class GalleryComment {
  const GalleryComment({
    required this.name,
    required this.time,
    required this.span,
    required this.score,
    this.vote,
    this.id,
    this.canEdit,
    this.canVote,
  });

  final String name;
  final String time;
  final List<GalleryCommentSpan> span;
  final String score;
  final int? vote;
  final String? id;
  final bool? canEdit;
  final bool? canVote;

  factory GalleryComment.fromJson(Map<String, dynamic> json) => GalleryComment(
      name: json['name'] as String,
      time: json['time'] as String,
      span: (json['span'] as List)
          .map((e) => GalleryCommentSpan.fromJson(e as Map<String, dynamic>))
          .toList(),
      score: json['score'] as String,
      vote: json['vote'] != null ? json['vote'] as int : null,
      id: json['id'] != null ? json['id'] as String : null,
      canEdit: json['can_edit'] != null ? json['can_edit'] as bool : null,
      canVote: json['can_vote'] != null ? json['can_vote'] as bool : null);

  Map<String, dynamic> toJson() => {
        'name': name,
        'time': time,
        'span': span.map((e) => e.toJson()).toList(),
        'score': score,
        'vote': vote,
        'id': id,
        'can_edit': canEdit,
        'can_vote': canVote
      };

  GalleryComment clone() => GalleryComment(
      name: name,
      time: time,
      span: span.map((e) => e.clone()).toList(),
      score: score,
      vote: vote,
      id: id,
      canEdit: canEdit,
      canVote: canVote);

  GalleryComment copyWith(
          {String? name,
          String? time,
          List<GalleryCommentSpan>? span,
          String? score,
          int? vote,
          String? id,
          bool? canEdit,
          bool? canVote}) =>
      GalleryComment(
        name: name ?? this.name,
        time: time ?? this.time,
        span: span ?? this.span,
        score: score ?? this.score,
        vote: vote ?? this.vote,
        id: id ?? this.id,
        canEdit: canEdit ?? this.canEdit,
        canVote: canVote ?? this.canVote,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GalleryComment &&
          name == other.name &&
          time == other.time &&
          span == other.span &&
          score == other.score &&
          vote == other.vote &&
          id == other.id &&
          canEdit == other.canEdit &&
          canVote == other.canVote;

  @override
  int get hashCode =>
      name.hashCode ^
      time.hashCode ^
      span.hashCode ^
      score.hashCode ^
      vote.hashCode ^
      id.hashCode ^
      canEdit.hashCode ^
      canVote.hashCode;
}
