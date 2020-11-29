import 'package:app2020/navigation.dart';
import 'package:dio/dio.dart';
import 'package:json_table/json_table.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class SimpleTable extends StatefulWidget {
  @override
  _SimpleTableState createState() => _SimpleTableState();
}

class _SimpleTableState extends State<SimpleTable> {
  final String title = "Leader Board";
  List users = [];
 

  @override
  void initState() {
    this._makeApiCall();
    super.initState();
  } 

  Future _makeApiCall() async {
    
    Dio dio = new Dio();

    Response apiResponse = await dio.get(link +
        '/get_leaderboard'); //Where id is just a parameter in GET api call
    print(apiResponse.data.toString());

    if (apiResponse.statusCode == 200) {
      var item = (apiResponse.data)["data"];
      setState(() {
        users = item;
        
      });
    } else {
      
      users = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    var json = users;
    return new MaterialApp(
        title: "Leaderboard",
        theme: ThemeData(fontFamily: "Open sans"),
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
            length: 5,
            child: Scaffold(
              appBar: new AppBar(
                backgroundColor: Color(0xFF1F2833),
                title: new Text('LeaderBoard'),
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new App()));
                  },
                ),
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(15.0),
                child: Container(
                    child: Column(
                  children: [
                    JsonTable(
                      json,
                      showColumnToggle: false,
                      tableHeaderBuilder: (String header) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10.0),
                          decoration: BoxDecoration(
                              border: Border.all(width: 0),
                              color: Colors.white.withOpacity(0)),
                          child: Text(
                            header,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                // ignore: deprecated_member_use
                                .display1
                                .copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0,
                                    color: Colors.black87),
                          ),
                        );
                      },
                      tableCellBuilder: (value) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 8.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0,
                                  color: Colors.white.withOpacity(0))),
                          child: Text(
                            value,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                // ignore: deprecated_member_use
                                .display1
                                .copyWith(fontSize: 16.0, color: Colors.black),
                          ),
                        );
                      },
                    ),
                  ],
                )),
              ),
            )));
  }
}
