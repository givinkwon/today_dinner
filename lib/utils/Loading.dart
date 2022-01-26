import 'package:flutter/cupertino.dart';

Widget Loading(BuildContext context) {
  {
    return Container(
        color: Color.fromRGBO(255, 255, 255, 1),
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          'assets/loading.gif',
        ));
  }
}
