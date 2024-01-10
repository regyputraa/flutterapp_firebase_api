import 'package:flutter/material.dart';
import 'package:flutter_application/LoginPage.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_application/constants/colors.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Text(
        'APKU!',
        style: TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      ),
      nextScreen: LoginPage(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: CustomColors
          .mainColor, // Menggunakan CustomColors.mainColor dari colors.dart
      duration: 3000, // Durasi tampilan splash screen (dalam milidetik)
    );
  }
}
