import 'package:clique/data/models/signup_params.dart';
import 'package:clique/data/models/user_registration_response.dart';
import 'package:get/get.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';

class AuthRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  Future<UserRegistrationResponse> registerUser(SignupParams request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.register,
        body: request.toJson(),
        headers: {"Content-Type": "application/json"},
      );
      return UserRegistrationResponse.fromJson(response);
    } catch (e) {
      // print("Signup Failed in repository: $e");
      Get.snackbar("Signup Failed", e.toString());
      throw Exception("Signup Failed: $e");
    }
  }

  Future<UserRegistrationResponse> loginUser(Map<String, String> credentials) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.login,
        body: credentials,
        headers: {"Content-Type": "application/json"},
      );
      Get.snackbar("Login Success", "Login Successfully");
      return UserRegistrationResponse.fromJson(response);
    } catch (e) {
      print("Login Failed in repository: $e");
      Get.snackbar("Login Failed", "Login Failed");
      throw Exception("Login Failed: $e");
    }
  }
}
