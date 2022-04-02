import 'package:flutter/material.dart';
import 'package:reddit/errors/api_error.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'info_me.dart';
import 'search.dart';
import 'home.dart';

Future<String> unsubTo(String token, String name) async {
  String bearer = 'Bearer ' + token;
  final response = await http.post(
      Uri.parse(
          'https://oauth.reddit.com/api/subscribe?action=unsub&sr_name=$name'),
      headers: <String, String>{'authorization': bearer});
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return "";
  }
}

class Profile extends StatefulWidget {
  Profile(
      {Key? key,
      required final String this.access,
      required final String this.refresh})
      : super(key: key);
  final String access;
  final String refresh;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<Me> infos;
  late Future<List<Subscribe>> subs;
  var style = const TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0);

  @override
  void initState() {
    super.initState();
    infos = fetchMe(widget.access);
    subs = fetchSub(widget.access);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search for Subreddits',
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Search(
                            access: widget.access,
                            refresh: widget.refresh)));
              },
            ),
            IconButton(
              icon: const Icon(Icons.list),
              tooltip: 'List Subreddits',
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(
                            access: widget.access,
                            refresh: widget.refresh)));
              },
            ),
          ],
          backgroundColor: Colors.orange[300],
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder<Me>(
            future: infos,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var date = DateTime.fromMillisecondsSinceEpoch(
                    snapshot.data!.created.toInt() * 1000);
                String formattedDate =
                    DateFormat('dd-MM-yyyy – kk:mm').format(date);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.all(16.0)),
                    ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                        child: Image.network(
                          snapshot.data!.pp.split("?")[0],
                          scale: 1,
                          height: 125,
                          width: 125,
                        )),
                    Center(
                      child: Text('Welcome ' + snapshot.data!.name,
                          style: const TextStyle(fontSize: 20.0)),
                    ),
                    Flexible(
                        flex: 1,
                        child: ListView(
                            children: [
                              Column(
                                children: <Widget>[
                                  const Padding(padding: EdgeInsets.all(8.0)),
                                  Text(
                                      "Profanity filter on: " +
                                          snapshot.data!.profanity.toString(),
                                      style: const TextStyle(fontSize: 18.0)),
                                  // Text("Creation date: " + snapshot.data!.created),
                                  const Padding(padding: EdgeInsets.all(8.0)),
                                  Text(
                                      "Description: " +
                                          snapshot.data!.publicDescription,
                                      style: const TextStyle(fontSize: 18.0)),
                                  const Padding(padding: EdgeInsets.all(8.0)),
                                  Text("Date de création : " + formattedDate,
                                      style: const TextStyle(fontSize: 16.0)),
                                  const Padding(padding: EdgeInsets.all(8.0)),
                                  Text(
                                      "Karma : " +
                                          snapshot.data!.totalKarma.toString(),
                                      style: const TextStyle(fontSize: 18.0)),
                                  const Padding(padding: EdgeInsets.all(16.0)),
                              const Text("My subscriptions:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.0)),
                              const Padding(padding: EdgeInsets.all(8.0)),
                                ],
                              ),
                              FutureBuilder(
                                  future: subs,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const CircularProgressIndicator();
                                    } else {
                                      List<Subscribe> list =
                                          snapshot.data as List<Subscribe>;

                                      return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: list.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                        title: Row(
                                                          children: <Widget>[
                                                            Text(
                                                              list[index].name +
                                                                  '   Subs: ' +
                                                                  list[index]
                                                                      .nb
                                                                      .toString(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      18.0),
                                                            )
                                                          ],
                                                        ),
                                                        subtitle:
                                                            ElevatedButton(
                                                          onPressed: () => unsubTo(
                                                                  widget
                                                                      .access,
                                                                  list[index]
                                                                      .name)
                                                              .then((void t) {
                                                            Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext context) => Profile(
                                                                        access: widget
                                                                            .access,
                                                                        refresh:
                                                                            widget.refresh)));
                                                          }),
                                                          child: const Icon(
                                                              Icons.block),
                                                        ));
                                              });
                                    }
                                  })
                            ]))]);
              } else if (snapshot.hasError) {
                return const MeError();
              } else {
                return const Center (child:CircularProgressIndicator());
              }
            }));
  }
}
