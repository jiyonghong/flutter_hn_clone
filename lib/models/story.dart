class Story {
  final String by;
  final int? descendants;
  final int id;
  final List<int>? kids;
  final int? score;
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
    this.score,
    required this.time,
    required this.title,
    required this.type,
    this.url,
    this.text,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      by: json['by'] as String,
      descendants: json['descendants'] as int?,
      id: json['id'] as int,
      kids: json['kids'] != null
          ? List<int>.from(json['kids'].map((e) => e as int))
          : null,
      score: json['score'] as int?,
      time: json['time'] as int,
      title: json['title'] as String,
      type: json['type'] as String,
      url: json['url'] as String?,
      text: json['text'] as String?,
    );
  }
}
