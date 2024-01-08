import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppConstWidget {
  static toastMsg({required String msg, required Color backgroundColor}) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
