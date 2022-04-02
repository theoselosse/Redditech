//https://www.reddit.com/api/v1/authorize?client_id=oiT0ZzI5v6QSLmPaxFLi6A&response_type=code&state=1ricardetcarepart&redirect_uri=https://www.reddit.com/api/v1/access_token&duration=temporary&scope=mysubreddits vote subscribe submit save read identity

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'request.dart';

void main() => runApp(const MaterialApp( 
      title: 'Navigation Basics',
      home: Login()
    )
   );

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea (
        child: Wrap (
        direction: Axis.horizontal,
        children: [
          const Padding(
            padding: EdgeInsets.all(32.0)
          ),
          const Center(
            child: Text(
                'Welcome on Redditech',
                style: TextStyle(fontSize: 24, color: Colors.white, decoration: TextDecoration.none),
            ),
        ),
        const Padding(
            padding: EdgeInsets.all(16.0)
          ),
        Center(
          child: ElevatedButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyApp()),
          )
        },
        child: const Text("Login"),
        style: ElevatedButton.styleFrom(
            primary: Colors.orange[300],
            textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      )),
        ]
    )));
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.orange),
        home: Scaffold(
            appBar: AppBar(
                title: const Text('Redditech')),
            body: const Autorization()));
  }
}