import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable()
class Story {
  final String by;
  final int? descendants;
  final int id;
  final List<int>? kids;
  final int score;
  final int time;
  final String title;
  final String type;
  final String? url;
  final String? text;

  Story({
    required this.by,
    this.descendants,
    required this.id,
    this.kids,
    required this.score,
    required this.time,
    required this.title,
    required this.type,
    this.url,
    this.text,
  });

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
