import 'package:flutter/material.dart';
import 'package:reddit/subreddits.dart';
import 'profile.dart';

class Search extends StatefulWidget {
  const Search(
      {Key? key, required final this.access, required final this.refresh})
      : super(key: key);
  final String access;
  final String refresh;

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _widgetOptions() => [
        SearchSubbreddits(access: widget.access, refresh: widget.refresh),
        const SearchUsers(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetsOptions = _widgetOptions();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        actions: <Widget>[
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
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'List Subreddits',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profile(
                          access: widget.access, refresh: widget.refresh)));
            },
          ),
        ],
      ),
      body: Center(
        child: widgetsOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Subreddits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Users',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class SearchUsers extends StatefulWidget {
  const SearchUsers({Key? key}) : super(key: key);

  @override
  SearchUsersState createState() => SearchUsersState();
}

class SearchUsersState extends State<SearchUsers> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Flexible(
          child: TextField(
        controller: _controller,
        onChanged: (String v) async {
          
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Users',
        ),
      )),

    ]);}
}

class SearchSubbreddits extends StatefulWidget {
  const SearchSubbreddits(
      {Key? key,
      required final String this.access,
      required final String this.refresh})
      : super(key: key);
  final String access;
  final String refresh;

  @override
  SearchSubbredditsState createState() => SearchSubbredditsState();
}

class SearchSubbredditsState extends State<SearchSubbreddits> {
  final TextEditingController _controller = TextEditingController();

  late Future<List<Sub>> subr = fetchSubr(widget.access, '');
  late var value;

  @override
  void initState() {
    super.initState();
    subr = fetchSubr(widget.access, '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Flexible(
          child: TextField(
        controller: _controller,
        onChanged: (String v) async {
          subr = fetchSubr(widget.access, v);
          setState(() => value = v);
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Subreddits',
        ),
      )),
      Flexible(
          child: FutureBuilder(
              future: subr,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  List<Sub> list = snapshot.data as List<Sub>;
                  return Container(
                      margin: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                                child: ListTile(
                              title: Text(list[index].name + '   '),
                              subtitle: Text(list[index].subscriber.toString()),
                              trailing: ElevatedButton(
                                onPressed: () =>
                                    subTo(widget.access, list[index].name),
                                child: const Icon(Icons.add_circle),
                              ),
                            ));
                          }));
                }
              }))
    ]);
  }
}
