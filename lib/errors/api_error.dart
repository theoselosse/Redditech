import 'package:flutter/material.dart';

class MeError extends StatelessWidget {
  const MeError({Key? key}) : super(key: key);
  @override Widget build(context) {
    return Scaffold(
      body: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
        Center(child: Text('Oops something went wrong...')),
        Image (image: NetworkImage('https://assets.pando.com/_versions/2013/03/broken_reddit_featured.jpg'),
        ),
        Center(child: Text('Coudln\'t access Profile Info')),
        ])
      );
  }
}