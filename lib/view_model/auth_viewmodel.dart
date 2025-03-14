
import 'dart:developer';
import 'package:clique/data/models/signup_params.dart';
import 'package:clique/data/models/user_registration_response.dart';
import 'package:clique/data/repositories/auth_respository.dart';
import 'package:clique/utils/utils.dart';
import 'package:get/get.dart';
import '../core/api/api_response.dart';

class AuthViewModel extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();
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
    } catch (e) {
      loginResponse.value = ApiResponse.error(Utils.mapErrorMessage(e.toString()));
    }
  }
}


