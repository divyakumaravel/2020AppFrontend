import 'package:app2020/constants.dart';
import 'package:app2020/navigation.dart';
import 'package:flutter/material.dart';
import 'package:app2020/Components/already_have_an_account_check.dart';
import 'package:app2020/Components/rounded_button.dart';
import 'package:app2020/Components/rounded_input_field.dart';
import 'package:app2020/Components/rounded_password_field.dart';
import 'package:app2020/Screens/Login/components/background.dart';
import 'package:app2020/Screens/Signup/signup_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter_session/flutter_session.dart';

// ignore: must_be_immutable
class Body extends StatelessWidget {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  Response apiResponse;

  Future<void> _makeApiCall() async {
    //var a=200;
    Dio dio = new Dio();
    apiResponse = await dio.post(link+'/login', data: {
      "username": nameController.text,
      "password": passwordController.text
    }); //Where id is just a parameter in GET api call
    //var session = FlutterSession();
    //await session.set("user", (apiResponse.data)["data"]["username"]);
    //await session.set("email", (apiResponse.data)["data"]["email"]);
    //await session.set("userid", (apiResponse.data)["data"]["userid"]);
    print(apiResponse.data.toString());
    return;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            Image.asset(
              "assets/icons/login.png",
              height: size.height * 0.25,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            RoundedInputField(
              controller: nameController,
              hintText: "User Name",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              controller: passwordController,
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "LOGIN",
              press: () async {
                await _makeApiCall();
                if ((apiResponse.data)["status"] == 200) {
                  var session = FlutterSession();
                  await session.set('username', nameController.text);
                  await session.set(
                      'email', (apiResponse.data)["data"]["user"]["email"]);
                  await session.set('useridentity', (apiResponse.data)["data"]["user"]["userid"]);
                  print("navigating...");
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new App()));
                }
              },
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
