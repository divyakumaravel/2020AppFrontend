import 'package:app2020/movies.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'constants.dart';

// ignore: camel_case_types
class movieForm extends StatefulWidget {
  final String title;
  movieForm(this.title);

  @override
  _movieFormState createState() => _movieFormState();
}

// ignore: camel_case_types
class _movieFormState extends State<movieForm> {
  String userid;
  var rating = 3.0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;

  String _bookname;

  String _author;

  String _rating;

  String _genre;

  String _stars;

  final _nameController = TextEditingController();

  final _directorController = TextEditingController();

  final _genreController = TextEditingController();

  void _makeApiCall(context) async {
    print('into make api call');
    var id = await FlutterSession().get('useridentity');
    String userid = id.toString();
    Dio dio = new Dio();
    Response apiResponse = await dio.post(link + '/upload_movie', data: {
      "name": _nameController.text,
      "director": _directorController.text,
      "genre": _genreController.text,
      "rating": _stars,
      "userid": userid
    });
    //Where id is just a parameter in GET api call
    print(apiResponse.data.toString());
    print('--------');
    print(userid);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Movies'),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Example1()));
            }),
      ),
      body: new SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.all(15.0),
          child: new Form(
            key: _formKey,
            // ignore: deprecated_member_use
            autovalidate: _autoValidate,
            child: FormUI(context),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget FormUI(context) {
    return new Column(
      children: <Widget>[
        new TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Movie Name'),
          keyboardType: TextInputType.text,
          validator: (value) =>
              value.isEmpty ? 'Movie name can\'t be empty' : null,
          onSaved: (value) => _bookname = value,
        ),
        new TextFormField(
          controller: _directorController,
          decoration: const InputDecoration(labelText: 'Director'),
          keyboardType: TextInputType.text,
          validator: (value) =>
              value.isEmpty ? 'Director can\'t be empty' : null,
          onSaved: (value) => _author = value,
        ),
        new TextFormField(
          controller: _genreController,
          decoration: const InputDecoration(labelText: 'Genre'),
          keyboardType: TextInputType.text,
          validator: (value) => value.isEmpty ? 'Genre can\'t be empty' : null,
          onSaved: (value) => _genre = value,
        ),
        new SmoothStarRating(
          rating: rating,
          isReadOnly: false,
          size: 40,
          filledIconData: Icons.star,
          halfFilledIconData: Icons.star_half,
          defaultIconData: Icons.star_border,
          starCount: 5,
          allowHalfRating: true,
          spacing: 2.0,
          onRated: (value) {
            _stars = value.toString();
            print(_stars);
          },
        ),
        new SizedBox(
          height: 20.0,
        ),
        new RaisedButton(
          shape: StadiumBorder(),
          onPressed: () {
            _validateInputs();
            _makeApiCall(context);
          },
          child: Text("Update"),
          color: Colors.blueGrey,
        ),
      ],
    );
  }

  void _validateInputs() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
    } else {
      print("Form is invalid");
    }
  }
}
