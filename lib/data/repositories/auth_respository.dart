import 'package:clique/data/models/signup_params.dart';
import 'package:clique/data/models/user_registration_response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

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
      print("Signup Failed in repository: $e");
      throw Exception("Signup Failed: $e");
    }
  }
}
