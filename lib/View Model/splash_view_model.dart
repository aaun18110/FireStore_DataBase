import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Services/splash_services.dart';

class SplashViewModel extends StatefulWidget {
  const SplashViewModel({super.key});

  @override
  State<SplashViewModel> createState() => _SplashViewModelState();
}

class _SplashViewModelState extends State<SplashViewModel> {
  SplashServices splashServices = SplashServices();
  @override
  void initState() {
    super.initState();
    splashServices.splashScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDualRing(
          color: Colors.lime.shade300,
        ),
      ),
    );
  }
}
