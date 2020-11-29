// ignore: avoid_web_libraries_in_flutter
import 'package:app2020/Screens/Login/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'Books.dart';
import 'LeaderBoard.dart';
import 'constants.dart';
import 'movies.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2020 App',
      theme: ThemeData(
        primaryColor: Color(0xFF1F2833),
      ),
      home: MyHomePage(title: '2020 App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('2020 App'),
        backgroundColor: Color(0xFF1F2833),
      ),
      body: new Feed(),
    );
  }
}

// ignore: must_be_immutable
class NavDrawer extends StatelessWidget {
  String username;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new FutureBuilder(
              future: FlutterSession().get('username'),
              builder: (context, snapshot) {
                username = snapshot.data.toString();
                print("username");
                print(username);
                return Text(
                    snapshot.hasData ? snapshot.data.toString() : 'Loading...');
              },
            ),
            accountEmail: new FutureBuilder(
              future: FlutterSession().get('email'),
              builder: (context, snapshot) {
                return Text(
                    snapshot.hasData ? snapshot.data.toString() : 'Loading...');
              },
            ),
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Color(0xFFBA8289),
              child: new FutureBuilder(
                future: FlutterSession().get('username'),
                builder: (context, snapshot) {
                  return Text(snapshot.hasData
                      ? snapshot.data.toString().toUpperCase()[0]
                      : 'Loading...');
                },
              ),
              // style: TextStyle(fontSize: 30, color: Colors.black),
            ),
            decoration: new BoxDecoration(
              color: Color(0xFF1F2833),
              /*image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/2020App.png'))*/
            ),
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Books'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Example()));
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_roll),
            title: Text('Movies'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Example1()));
            },
          ),
          ListTile(
            leading: Icon(Icons.card_membership),
            title: Text('LeaderBoard'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new SimpleTable()));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}

class Feed extends StatefulWidget {
  Feed({Key key}) : super(key: key);

  feedPage createState() => feedPage();
}

// ignore: camel_case_types
class feedPage extends State<Feed> {
  List users = [];
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    this._makeApiCall();
  }

  Future _makeApiCall() async {
    setState(() {
      isloading = true;
    });
    Dio dio = new Dio();
    Response apiResponse = await dio
        .get(link + '/get_feed'); //Where id is just a parameter in GET api call
    print(apiResponse.data.toString());
    if (apiResponse.statusCode == 200) {
      var item = (apiResponse.data)["data"];
      setState(() {
        users = item;
        isloading = false;
      });
    } else {
      users = [];
      isloading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      footerTriggerDistance: 15,
      dragSpeedRatio: 0.91,
      headerBuilder: () => MaterialClassicHeader(),
      footerBuilder: () => ClassicFooter(),
      enableLoadingWhenNoData: false,
      shouldFooterFollowWhenNotFull: (state) {
        // If you want load more with noMoreData state ,may be you should return false
        return false;
      },
      child: Scaffold(
        body: getfeed(),
      ),
    );
  }

  Widget getfeed() {
    if (users.contains(null) || users.length < 0 || isloading) {
      return Center(
        child: Center(
          child: SpinKitFadingCube(
            color: Colors.black,
            size: 70.0,
          ),
        ),
      );
    }
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return getCardUI(users[index]);
        });
  }

  // ignore: missing_return
  Widget getCardUI(item) {
    var name = item['name'];
    var author = item['author'];
    var director = item['director'];
    var type = item['type'];
    var username = item['username'];
    var rate = item['rating'];
    var date = item['date'];
    if (type == "book") {
      return Card(
        elevation: 1.5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            title: Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 140,
                        child: Text(
                          name,
                          style: TextStyle(fontSize: 17),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      author,
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      username + " rated this book with " + rate + " stars",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      date,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
    if (type == "movie") {
      return Card(
        elevation: 1.5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            title: Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 140,
                        child: Text(
                          name,
                          style: TextStyle(fontSize: 17),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      director,
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      username + " rated this movie with " + rate + " stars",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      date,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
