import 'package:app2020/moviesUpdate.dart';
import 'package:app2020/navigation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'configuration.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'constants.dart';

Response apiResponse;

class Example1 extends StatefulWidget {
  Example1({Key key}) : super(key: key);
  moviePage createState() => moviePage();
}

// ignore: camel_case_types
class moviePage extends State<Example1> {
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
    var id = await FlutterSession().get('useridentity');
    String userid = id.toString();
    Dio dio = new Dio();
    apiResponse = await dio.get(link +
        '/get_movie/' +
        userid); //Where id is just a parameter in GET api call
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
        appBar: AppBar(
          title: Text("Movies"),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new App()));
              }),
        ),
        body: getbody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
//          Navigator.of(context).pop();
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new movieForm("Movies")));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  // ignore: missing_return
  Widget getbody() {
    if (isloading) {
      return Center(
        child: Center(
          child: SpinKitFadingCube(
            color: Colors.black,
            size: 70.0,
          ),
        ),
      );
    }
    if ((apiResponse.data)["statuscode"] == 200) {
      return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return getCard(users[index]);
          });
    }
  }

  Widget getCard(item) {
    var name = item['name'];
    var director = item['director'];
    var genre = item['genre'];
    print(name);
    return Card(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 240,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[100],
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: shadowList,
                          ),
                          margin: EdgeInsets.only(top: 40),
                        ),
                        Align(
                          child: Image.network(
                            'https://previews.123rf.com/images/flas100/flas1001310/flas100131000151/23212118-old-motion-picture-film-reel-with-film-strip-vintage-background.jpg',
                            height: 200,
                            width: double.infinity,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 60, bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: shadowList,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                      ),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            name,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            director,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.black45,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            genre,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.black45,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
