import 'package:app2020/constants.dart';
import 'package:flutter/material.dart';
import 'package:app2020/Components/already_have_an_account_check.dart';
import 'package:app2020/Components/rounded_button.dart';
import 'package:app2020/Components/rounded_input_field.dart';
import 'package:app2020/Components/rounded_password_field.dart';
import 'package:app2020/Screens/Login/login_screen.dart';
import 'package:app2020/Screens/Signup/components/background.dart';
import 'package:dio/dio.dart';

// ignore: must_be_immutable
class Body extends StatelessWidget {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  Response apiResponse;

  void _makeApiCall() async {
    Dio dio = new Dio();
    apiResponse = await dio.post(link + '/signup', data: {
      "username": nameController.text,
      "email": emailController.text,
      "password": passwordController.text
    }); //Where id is just a parameter in GET api call
    print(apiResponse.data.toString());
    if (apiResponse.statusCode == 200) {
      print("Success");
    } else {
      print("Failure");
    }
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
              "SIGN UP",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Image.asset(
              "assets/icons/signup.png",
              height: size.height * 0.2,
            ),
            RoundedInputField(
              controller: nameController,
              hintText: "User Name",
              onChanged: (value) {},
            ),
            RoundedInputField(
              controller: emailController,
              hintText: "Email Id",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              controller: passwordController,
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "SIGN UP",
              press: () {
                _makeApiCall();
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new LoginScreen()));
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
