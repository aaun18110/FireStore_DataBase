import 'package:firestore_database/Model/button.dart';
import 'package:firestore_database/Services/error_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Utils/Routes/route_name.dart';

class ForgotPasswordViewModel extends StatefulWidget {
  const ForgotPasswordViewModel({super.key});

  @override
  State<ForgotPasswordViewModel> createState() =>
      _ForgotPasswordViewModelState();
}

class _ForgotPasswordViewModelState extends State<ForgotPasswordViewModel> {
  final formKey = GlobalKey<FormState>();
  final forgotController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  void dispose() {
    super.dispose();
    forgotController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: formKey,
                  child: TextFormField(
                    controller: forgotController,
                    decoration: const InputDecoration(
                        hintText: "Enter your email",
                        prefixIcon: Icon(Icons.alternate_email_outlined)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your correct user_email";
                      } else {
                        return null;
                      }
                    },
                  )),
              const SizedBox(
                height: 30,
              ),
              Button(
                  title: "Forgot",
                  loading: loading,
                  onpress: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      auth
                          .sendPasswordResetEmail(
                              email: forgotController.text.toString())
                          .then((value) {
                        setState(() {
                          loading = false;
                        });
                        ErrorMessage.toastMessage(
                            "Please check your Email Reset the password link.");
                        Navigator.pushNamed(context, RouteName.loginViewModel);
                      }).onError((error, stackTrace) {
                        setState(() {
                          loading = false;
                        });
                        ErrorMessage.toastMessage(error.toString());
                      });
                    }
                  })
            ]),
      ),
    );
  }
}
