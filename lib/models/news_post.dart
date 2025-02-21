import 'dart:convert';

List<NewsPost> newsPostFromJson(String str) =>
    List<NewsPost>.from(json.decode(str).map((x) => NewsPost.fromJson(x)));

String newsPostToJson(List<NewsPost> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewsPost {
  int id;
  int userId;
  String title;
  String body;

  NewsPost({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory NewsPost.fromJson(Map<String, dynamic> json) => NewsPost(
    id: json["id"],
    userId: json["userId"],
    title: json["title"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "title": title,
    "body": body,
  };
}
