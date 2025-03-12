
import 'dart:developer';

import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/models/signup_params.dart';
import 'package:clique/data/models/user_registration_response.dart';
import 'package:clique/data/repositories/auth_respository.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:clique/utils/utils.dart';
import 'package:clique/view/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/api/api_response.dart';

class AuthViewModel extends GetxController {
  final AuthRepository _authRepo = AuthRepository();
  final Rx<ApiResponse<UserRegistrationResponse>> signupResponse = ApiResponse<UserRegistrationResponse>.loading().obs;
  final Rx<ApiResponse<UserRegistrationResponse>> loginResponse = ApiResponse<UserRegistrationResponse>.loading().obs;
  final RxBool isLoading = false.obs;
  Future<void> registerUser(SignupParams request, String userName) async {
    try {
      signupResponse.value = ApiResponse.loading();
     await _authRepo.registerUser(request);
      
              // signupResponse.value = ApiResponse.completed(response);
      // Get.find<UserController>().saveUserSession(response, userName, );

    } catch (e) {
      signupResponse.value = ApiResponse.error(Utils.mapErrorMessage(e.toString()));
    }
  }

  Future<void> loginUser(String email, String password, context) async {
        log(email);
        log(password);
    try {
      loginResponse.value = ApiResponse.loading();
      final response = await _authRepo.loginUser({
           "email": email,
        "password": password,

      });
        // final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    //  Navigator.push(
    //           context,
    //           PageRouteBuilder(
    //             pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
    //             transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //               const begin = Offset(1.0, 0.0); // Slide from right
    //               const end = Offset.zero;
    //               const curve = Curves.easeInOut;

    //               var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    //               var offsetAnimation = animation.drive(tween);

    //               return SlideTransition(
    //                 position: offsetAnimation,
    //                 child: child,
    //               );
    //             },
    //           ),
    //         );
    } catch (e) {
      loginResponse.value = ApiResponse.error(Utils.mapErrorMessage(e.toString()));
    }
  }
}


