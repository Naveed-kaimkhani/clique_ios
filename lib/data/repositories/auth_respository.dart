

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clique/data/models/signup_params.dart';
import 'package:clique/data/models/user_registration_response.dart';
import 'package:clique/utils/utils.dart';
import 'package:get/get.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';

class AuthRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  Future<void> registerUser(SignupParams request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.register,
        body: request.toJson(),
        headers: {"Content-Type": "application/json"},
      );
      // return UserRegistrationResponse.fromJson(response);
      // return response;
    } catch (e) {
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
      Utils.showCustomSnackBar("Login Failed", Utils.mapErrorMessage(e.toString()), ContentType.failure);
      throw Exception("Login Failed: $e");
    }
  }
}
