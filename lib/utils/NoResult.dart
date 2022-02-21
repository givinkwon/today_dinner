import 'package:flutter/cupertino.dart';

Widget NoResult(BuildContext context) {
  {
    return Container(
        color: Color.fromRGBO(255, 255, 255, 1),
        width: MediaQuery.of(context).size.width * 0.65,
        child: Image.asset(
          'assets/result_not.png',
        ));
  }
}
