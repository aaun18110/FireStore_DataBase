import 'package:flutter/material.dart';
import '../Utils/App Color/app_colors.dart';

class Button extends StatelessWidget {
  final String title;
  final VoidCallback onpress;
  final bool loading;
  const Button(
      {super.key,
      required this.title,
      required this.onpress,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onpress,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 50,
            decoration: BoxDecoration(
                color: AppColors.colorButton,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.8, 3),
                      blurRadius: 4)
                ]),
            child: Center(
                child: loading
                    ? const CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      )
                    : Text(
                        title,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      )),
          ),
        ));
  }
}
