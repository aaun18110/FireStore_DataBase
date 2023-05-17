import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Utils/Routes/route_name.dart';

class SplashServices {
  final auth = FirebaseAuth.instance;
  void splashScreen(BuildContext context) {
    final user = auth.currentUser;
    if (user == null) {
      Timer(const Duration(seconds: 2), () {
        Navigator.pushNamed(context, RouteName.loginViewModel);
      });
    } else {
      Timer(const Duration(seconds: 2), () {
        Navigator.pushNamed(context, RouteName.imageUploadViewModel);
      });
    }
  }
}
