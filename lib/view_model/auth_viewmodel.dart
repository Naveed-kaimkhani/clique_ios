import 'package:clique/data/models/signup_params.dart';
import 'package:clique/data/models/user_registration_response.dart';
import 'package:clique/data/repositories/auth_respository.dart';
import 'package:get/get.dart';
import '../core/api/api_response.dart';

class AuthViewModel extends GetxController {
  final AuthRepository _authRepo = AuthRepository();
  final Rx<ApiResponse<UserRegistrationResponse>> signupResponse = ApiResponse<UserRegistrationResponse>.loading().obs;

  Future<void> registerUser(SignupParams request) async {
    try {
      signupResponse.value = ApiResponse.loading();
      final response = await _authRepo.registerUser(request);
      signupResponse.value = ApiResponse.completed(response);
    } catch (e) {
      signupResponse.value = ApiResponse.error(e.toString());
    }
  }
}
