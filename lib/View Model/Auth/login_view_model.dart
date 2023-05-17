import 'package:firestore_database/Services/error_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Model/button.dart';
import '../../Utils/Routes/route_name.dart';

class AuthLoginViewModel extends StatefulWidget {
  const AuthLoginViewModel({super.key});

  @override
  State<AuthLoginViewModel> createState() => _AuthLoginViewModelState();
}

class _AuthLoginViewModelState extends State<AuthLoginViewModel> {
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isHidden = ValueNotifier<bool>(true);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  bool loading = false;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordNode.dispose();
    emailNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: formKey,
                  child: ValueListenableBuilder(
                      valueListenable: _isHidden,
                      builder: (context, value, child) {
                        return Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.alternate_email_sharp),
                                  hintText: "Enter Your Email Address"),
                              focusNode: emailNode,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(passwordNode);
                              },
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Email Required';
                                } else if (!val.contains("@") ||
                                    !val.contains('.')) {
                                  return 'sample@gmail.com';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: height * 0.020,
                            ),
                            TextFormField(
                                controller: passwordController,
                                obscureText: _isHidden.value,
                                obscuringCharacter: '*',
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.lock_outline_rounded),
                                    hintText: "Enter Your Password",
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          _isHidden.value = !_isHidden.value;
                                        },
                                        child: Icon(_isHidden.value
                                            ? Icons.visibility_off
                                            : Icons.visibility_rounded))),
                                focusNode: passwordNode,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Password Required';
                                  } else if (val.length < 8) {
                                    return 'Maximum use 8 Character';
                                  } else {
                                    return null;
                                  }
                                }),
                          ],
                        );
                      })),
              SizedBox(
                height: height * 0.085,
              ),
              Button(
                title: "Login",
                loading: loading,
                onpress: () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    auth
                        .signInWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordController.text.toString())
                        .then((value) {
                      setState(() {
                        loading = false;
                      });
                      ErrorMessage.toastMessage("Sucessfully Login");
                      Navigator.pushNamed(context, RouteName.postViewModel);
                    }).onError((error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                      ErrorMessage.toastMessage(error.toString());
                      return null;
                    });
                  }
                },
              ),
              SizedBox(
                height: height * 0.010,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                      context, RouteName.forgetPasswordViewModel);
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.lime.shade800,
                        fontSize: 14),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Dont't have an Account?",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteName.signupViewModel);
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            color: Colors.lime.shade800, fontSize: 16),
                      )),
                ],
              ),
            ]),
      ),
    );
  }
}
