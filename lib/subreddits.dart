import 'package:http/http.dart' as http;
import 'dart:convert';

class Sub {
  String name;
  int subscriber;

  Sub({
    required this.name,
    required this.subscriber,
  }
  );

  factory Sub.fromJson(dynamic json) {
    return Sub(
      name: json['name'] as String,
      subscriber: json['numSubscribers'] as int);
  }

  @override
  String toString() {
    return '{ $name, $subscriber }';
  }
}

Future<List<Sub>> fetchSubr(String token, String str) async {
  String bearer = 'Bearer ' + token;
  final response = await http
      .get(Uri.parse('https://oauth.reddit.com/api/subreddit_autocomplete?query=$str'),
      headers: <String, String>{'authorization': bearer});
  if (response.statusCode == 200) {
    var tagObjsJson = jsonDecode(response.body)['subreddits'] as List;
    List<Sub> tagObjs = tagObjsJson.map((tagJson) => Sub.fromJson(tagJson)).toList();
    return tagObjs;
  } else {
    throw Exception('Failed to fetch subreddits');
  }
}

Future<String> subTo(String token, String name) async {
  String bearer = 'Bearer ' + token;
  final response = await http.post(Uri.parse('https://oauth.reddit.com/api/subscribe?action=sub&sr_name=$name'),
  headers: <String, String>{'authorization': bearer});
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return "";
  }
}