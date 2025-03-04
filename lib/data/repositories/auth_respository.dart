

import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clique/data/models/signup_params.dart';
import 'package:clique/data/models/user_registration_response.dart';
import 'package:clique/utils/utils.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';

class AuthRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  Future<UserRegistrationResponse> registerUser(SignupParams request) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final response = await apiClient.post(
        ApiEndpoints.register,
        body: request.toJson(),
        headers: {"Content-Type": "application/json"},
      );
      await prefs.setString('uid', response["user"]["id"]);
      print(UserRegistrationResponse.fromJson(response));
      return UserRegistrationResponse.fromJson(response);

    } catch (e) {
      print("error in registerUser");
      print(e);
      Utils.showCustomSnackBar("Signup Failed", Utils.mapErrorMessage(e.toString()), ContentType.failure);
      throw Exception("Signup Failed: $e");
    }
  }

  Future<void> loginUser(Map<String, String> credentials) async {

    try {
      final response = await apiClient.post(
        ApiEndpoints.login,
        body: credentials,
        headers: {"Content-Type": "application/json"},
      );
   
      // return UserRegistrationResponse.fromJson(response);
    } catch (e) {
      print(e);
      Utils.showCustomSnackBar("Login Failed", Utils.mapErrorMessage(e.toString()), ContentType.failure);
      throw Exception("Login Failed: $e");
    }
  }
}
