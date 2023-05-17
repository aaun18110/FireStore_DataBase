import 'package:firestore_database/Utils/Routes/route_name.dart';
import 'package:firestore_database/View%20Model/Auth/forget_password_view_model.dart';
import 'package:flutter/material.dart';
import '../../View Model/Auth/login_view_model.dart';
import '../../View Model/Auth/signup_view_model.dart';
import '../../View Model/Post/addpost_view_model.dart';
import '../../View Model/Post/imageupload_view_model.dart';
import '../../View Model/Post/post_view_model.dart';
import '../../View Model/splash_view_model.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.loginViewModel:
        return MaterialPageRoute(
            builder: (context) => const AuthLoginViewModel());
      case RouteName.signupViewModel:
        return MaterialPageRoute(
            builder: (context) => const AuthSignupViewModel());
      case RouteName.splashViewModel:
        return MaterialPageRoute(builder: (context) => const SplashViewModel());
      case RouteName.postViewModel:
        return MaterialPageRoute(builder: (context) => const PostViewModel());
      case RouteName.addPostViewModel:
        return MaterialPageRoute(
            builder: (context) => const AddPostViewModel());
      case RouteName.forgetPasswordViewModel:
        return MaterialPageRoute(
            builder: (context) => const ForgotPasswordViewModel());
      case RouteName.imageUploadViewModel:
        return MaterialPageRoute(
            builder: (context) => const ImageUploadViewMode());
      default:
        return MaterialPageRoute(builder: (context) {
          return const Scaffold(
            body: Center(
                child: Text(
              "Page Not Found",
              style: TextStyle(fontSize: 25),
            )),
          );
        });
    }
  }
}
