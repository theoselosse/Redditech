import 'package:http/http.dart' as http;
import 'dart:convert';


class Top {
  String subr;
  String title;
  String author;

  Top({
    required this.subr,
    required this.title,
    required this.author,
  }
  );

  factory Top.fromJson(dynamic json) {
    return Top(
      subr: json['data']['subreddit'] as String,
      title: json['data']['title'] as String,
      author: json['data']['author'] as String,
    );
  }
}

Future<List<Top>> fetchTops(String token) async {
  String bearer = 'Bearer ' + token;
  final response = await http
      .get(Uri.parse('https://oauth.reddit.com/top'),
      headers: <String, String>{'authorization': bearer});
  if (response.statusCode == 200) {
    var tagObjsJson = jsonDecode(response.body)['data']['children'] as List;
    List<Top> tagObjs = tagObjsJson.map((tagJson) => Top.fromJson(tagJson)).toList();
    return tagObjs;
  } else {
    throw Exception('Failed to fetch subreddits');
  }
}


class Best {
  String subr;
  String title;
  String author;

  Best({
    required this.subr,
    required this.title,
    required this.author,
  }
  );

  factory Best.fromJson(dynamic json) {
    return Best(
      subr: json['data']['subreddit'] as String,
      title: json['data']['title'] as String,
      author: json['data']['author'] as String,
    );
  }
}

Future<List<Best>> fetchBest(String token) async {
  String bearer = 'Bearer ' + token;
  final response = await http
      .get(Uri.parse('https://oauth.reddit.com/best'),
      headers: <String, String>{'authorization': bearer});
  if (response.statusCode == 200) {
    var tagObjsJson = jsonDecode(response.body)['data']['children'] as List;
    List<Best> tagObjs = tagObjsJson.map((tagJson) => Best.fromJson(tagJson)).toList();
    return tagObjs;
  } else {
    throw Exception('Failed to fetch subreddits');
  }
}