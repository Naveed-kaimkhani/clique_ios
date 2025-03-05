import 'dart:developer';

import 'package:clique/constants/app_images.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/view/auth/login_screen.dart';
import 'package:clique/view/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  void _checkAuthentication() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate splash delay
    userController.loadUserSession();
    print(userController.token.value);
    if (userController.token.value.isNotEmpty) {
      log("usernameeeeee");
      print(userController.userName.value);
      Get.offAll(() => HomeScreen()); // Navigate to Home if logged in
    } else {
      Get.offAll(() => LoginScreen()); // Navigate to Login if not logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder(
          duration: Duration(milliseconds: 1500),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: Image.asset(
                AppImages.appLogo, 
                width: 220,
                height: 220,
              ),
            );
          },
        ),
      ),
    );
  }
}
