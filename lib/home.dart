import 'package:flutter/material.dart';
import 'profile.dart';
import 'search.dart';
import 'info_home.dart';

class Home extends StatefulWidget {
  const Home(
      {Key? key, required final this.access, required final this.refresh})
      : super(key: key);
  final String access;
  final String refresh;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  late Future<List<Top>> tops;
  late Future<List<Best>> best;

  @override
  void initState() {
    super.initState();
    tops = fetchTops(widget.access);
    best = fetchBest(widget.access);
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text("Subreddits"),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Search for Subreddits',
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Search(
                        access: widget.access, refresh: widget.refresh)));
          },
        ),
        IconButton(
          icon: const Icon(Icons.account_circle),
          tooltip: 'Profile',
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(
                        access: widget.access, refresh: widget.refresh)));
          },
        ),
      ],
      backgroundColor: Colors.orange[300],
      automaticallyImplyLeading: false,
    ),
    body:
      FutureBuilder<List<Top>> (
        future: tops,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Top> list = snapshot.data as List<Top>;
            return Center (
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ListTile (
                      title: Text(list[index].title),
                      subtitle: Text(list[index].subr),
                      trailing: Text(list[index].author),
                    );
                  }
                  ),
            );
          }
          else {
            return const Center (child:CircularProgressIndicator());
          }
        })
    );
  }
}
