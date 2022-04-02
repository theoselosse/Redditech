import 'package:flutter/material.dart';
import '../main.dart';

class Error extends StatelessWidget {
  @override Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions refused'),
      ),
      body: const Center(child: Text('An Error occurred while accepting required permissions')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  ),
        tooltip: 'Go Back to authorization',
        child: const Icon(Icons.arrow_back),
      )
      );
  }
}