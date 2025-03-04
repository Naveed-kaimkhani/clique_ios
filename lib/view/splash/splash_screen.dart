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
      print("usernameeeeee");
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
        child: CircularProgressIndicator(),
      ),
    );
  }
}
