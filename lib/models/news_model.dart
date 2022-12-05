import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NewsModel {
  final String author;
  final String content;
  final String date;
  final String imageUrl;
  final String? readMoreUrl;
  final String time;
  final String title;
  final String url;
  NewsModel({
    required this.author,
    required this.content,
    required this.date,
    required this.imageUrl,
    this.readMoreUrl,
    required this.time,
    required this.title,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'author': author,
      'content': content,
      'date': date,
      'imageUrl': imageUrl,
      'readMoreUrl': readMoreUrl,
      'time': time,
      'title': title,
      'url': url,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      author: map['author'] as String,
      content: map['content'] as String,
      date: map['date'] as String,
      imageUrl: map['imageUrl'] as String,
      readMoreUrl:
          map['readMoreUrl'] != null ? map['readMoreUrl'] as String : null,
      time: map['time'] as String,
      title: map['title'] as String,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsModel.fromJson(String source) =>
      NewsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
