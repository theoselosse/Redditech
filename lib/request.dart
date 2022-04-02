import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reddit/profile.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'errors/error.dart';

Future<String> getToken(String code) async {
  const String uri = 'https://eu.epitech.redditech://autorize';
  const String username = 'wbGWKvItru8ITcmuSUo0DA';
  const String password = 'Y5jTuiEhM-zlh3RjRNKTD1ueubdWmQ';
  String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

  var r = await http.post(
    Uri.parse("https://www.reddit.com/api/v1/access_token?grant_type=authorization_code&code=$code&redirect_uri=$uri"),
      headers: <String, String>{'authorization': basicAuth}
      );
    if (r.statusCode == 200) {
      return r.body;
    } else {
      throw ErrorDescription("Can't get Token");
    }
}

class Autorization extends StatefulWidget {
  const Autorization({Key? key}): super(key: key);
  @override
  _AutorizationState createState() => _AutorizationState();
}

class _AutorizationState extends State<Autorization> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold (
      body:
          SizedBox (
            height: double.infinity,
            child: WebView(
            onWebViewCreated: (WebViewController c) {
                _controller.complete(c);
              },
            initialUrl: 'https://www.reddit.com/api/v1/authorize.compact?client_id=wbGWKvItru8ITcmuSUo0DA&response_type=code&state=1ricardetcarepart&redirect_uri=https://eu.epitech.redditech://autorize&duration=permanent&scope=mysubreddits vote subscribe submit save read identity',                
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://eu.epitech')) {
                final Map<String, dynamic> _result = Uri.splitQueryString(request.url);
                if (_result.containsKey('code')) {
                  var res = _result['code'].substring(0, _result['code'].length - 2);
                  getToken(res).then((String result) {
                    var tok = jsonDecode(result);
                    Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Profile(access : tok['access_token'], refresh: tok['refresh_token'])));
                  });
                } else {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Error()),
                  );
                }
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          )
        ),
        ));
  }
}