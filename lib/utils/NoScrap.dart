import 'package:flutter/cupertino.dart';

Widget NoScrap(BuildContext context) {
  {
    return Container(
        color: Color.fromRGBO(255, 255, 255, 1),
        width: MediaQuery.of(context).size.width * 0.85,
        child: Image.asset(
          'assets/scrap_not.png',
        ));
  }
}
