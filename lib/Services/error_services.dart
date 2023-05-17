import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ErrorMessage {
  static toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP_RIGHT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.lime.shade200,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
