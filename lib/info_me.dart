// ignore: file_names

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Me> fetchMe(String token) async {
  String bearer = 'Bearer ' + token;
  final response = await http
      .get(Uri.parse('https://oauth.reddit.com/api/v1/me'),
      headers: <String, String>{'authorization': bearer});
  if (response.statusCode == 200) {
    return Me.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch me section');
  }
}

class Me {
  final bool profanity;
  final double created;
  final String pp;
  final String name;
  final String avatar;
  final String url;
  final int nbFriends;
  final String publicDescription;
  final int totalKarma;

  const Me({
    required this.profanity,
    required this.created,
    required this.pp,
    required this.name,
    required this.avatar,
    required this.url,
    required this.nbFriends,
    required this.publicDescription,
    required this.totalKarma,
  });
  factory Me.fromJson(Map<String, dynamic> json) {
    return Me(
      profanity: json['pref_no_profanity'] as bool,
      created: json['created_utc'] as double,
      pp: json['subreddit']['icon_img'] as String,
      name: json['subreddit']['display_name'] as String,
      avatar: json['snoovatar_img'] as String,
      url: json['subreddit']['url'] as String,
      publicDescription: json['subreddit']['public_description'] as String,
      nbFriends: json['num_friends'] as int,
      totalKarma: json['total_karma'] as int,
    );
  }
}


Future<List<Subscribe>> fetchSub(String token) async {
  String bearer = 'Bearer ' + token;
  final response = await http
      .get(Uri.parse('https://oauth.reddit.com/subreddits/mine/subscriber'),
      headers: <String, String>{'authorization': bearer});
  if (response.statusCode == 200) {
    var objs = jsonDecode(response.body)['data']['children'] as List;
    List<Subscribe> tagObjs = objs.map((tagJson) => Subscribe.fromJson(tagJson)).toList();
    return tagObjs;
  } else {
    throw Exception('Failed to fetch subscribed section');
  }
}

class Subscribe {
  final String name;
  final int nb;

  const Subscribe({
    required this.name,
    required this.nb,
  });
  factory Subscribe.fromJson(Map<String, dynamic> json) {
    return Subscribe(
      name: json['data']['display_name'] as String,
      nb: json['data']['subscribers'] as int,
    );
  }
}