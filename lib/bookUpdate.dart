import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'Books.dart';
import 'constants.dart';

// ignore: camel_case_types, must_be_immutable
class bookForm extends StatelessWidget {
  final databaseReference = FirebaseDatabase.instance.reference();
  final String title;
  bookForm(this.title);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _bookname;
  String _author;
  String _genre;
  String _stars;
  var rating = 3.0;

  final _nameController = TextEditingController();
  final _authorController = TextEditingController();
  final _genreController = TextEditingController();

  void _makeApiCall(context) async {
    var id = await FlutterSession().get('useridentity');
    String userid = id.toString();
    Dio dio = new Dio();
    Response apiResponse = await dio.post(link + '/upload_book', data: {
      "name": _nameController.text,
      "author": _authorController.text,
      "genre": _genreController.text,
      "rating": _stars,
      "userid": userid
    }); //Where id is just a parameter in GET api call
    print(apiResponse.data.toString());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Books'),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Example()));
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

// Here is our Form UI
  // ignore: non_constant_identifier_names
  Widget FormUI(context) {
    return new Column(
      children: <Widget>[
        new TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'book Name'),
          keyboardType: TextInputType.text,
          validator: (value) =>
              value.isEmpty ? 'Book name can\'t be empty' : null,
          onSaved: (value) => _bookname = value,
        ),
        new TextFormField(
          controller: _authorController,
          decoration: const InputDecoration(labelText: 'Author'),
          keyboardType: TextInputType.text,
          validator: (value) => value.isEmpty ? 'Author can\'t be empty' : null,
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
      /* AlertDialog(
        title: Text("Successfully Uploaded !"),
        actions: [
          FlatButton(
            child: Text("Ok"),
            onPressed: (){
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Example()));
            },
          )
        ],
      );
*/
    } else {
      print("Form is invalid");
    }
  }
}
