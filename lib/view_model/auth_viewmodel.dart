
import 'package:clique/data/models/signup_params.dart';
import 'package:clique/data/models/user_registration_response.dart';
import 'package:clique/data/repositories/auth_respository.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:clique/utils/utils.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/api_response.dart';

class AuthViewModel extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();

  final Rx<ApiResponse<UserRegistrationResponse>> signupResponse = ApiResponse<UserRegistrationResponse>.loading().obs;
  final Rx<ApiResponse<UserRegistrationResponse>> loginResponse = ApiResponse<UserRegistrationResponse>.loading().obs;
  final RxBool isLoading = false.obs;
  Future<void> registerUser(SignupParams request, String userName) async {
    try {
      isLoading.value = true;
      signupResponse.value = ApiResponse.loading();
     await _authRepo.registerUser(request);
      

    } catch (e) {
      signupResponse.value = ApiResponse.error(Utils.mapErrorMessage(e.toString()));
    }
  }
   Future<void> deleteUserAccount(int userId) async {
    final success = await _authRepo.deleteUser(userId);
    if (success) {
      // Clear local storage if needed
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      Get.back(); // Instead of Navigator.pop

      Get.offAllNamed(RouteName.loginScreen); // Navigate to login screen
    }
  }
}


