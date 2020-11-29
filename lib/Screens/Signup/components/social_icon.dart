import 'package:flutter/material.dart';
import 'package:app2020/constants.dart';

class SocialIcon extends StatelessWidget {
  final String iconsrc;
  final Function press;
  const SocialIcon({
    Key key,
    this.iconsrc,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: kPrimaryLightColor),
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          iconsrc,
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}
