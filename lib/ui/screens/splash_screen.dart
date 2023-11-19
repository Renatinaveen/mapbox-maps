import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../resources/assets_class.dart';
import '../../resources/constants.dart';
import '../../resources/fonts_class.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    redirectToHomeScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              Assets.animation,
              fit: BoxFit.cover,
            ),
            const Text(
              TextConstants.title,
              style: TextStyle(
                fontSize: FontsClass.fontSize32,
                fontFamily: FontsClass.poppinsFont,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void redirectToHomeScreen() {
    Future.delayed(const Duration(seconds: 1), () {
      // delay for 1 second for animation to complete
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(), // redirect to home screen
        ),
      );
    });
  }
}
