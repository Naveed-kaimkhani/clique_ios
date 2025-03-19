
import 'dart:convert';
import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/models/signup_params.dart';
import 'package:clique/models/otp_model.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:clique/utils/utils.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';

class AuthRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  final UserController userController = Get.put(UserController());
  Future<void> registerUser(SignupParams request) async {
    try {
      // final prefs = await SharedPreferences.getInstance();
     await apiClient.signUpApi(
        ApiEndpoints.register,
        body: request.toJson(),
        headers: {"Content-Type": "application/json"},
      );

    } catch (e) {
      Utils.showCustomSnackBar("Signup Failed", Utils.mapErrorMessage(e.toString()), ContentType.failure);
      // throw Exception("Signup Failed: $e");
    }
  }
    Future<OTPResponseModel> verifyOTP(OTPRequestModel otpRequest) async {
    try {
      final response = await apiClient.verifyOtp(
        url: ApiEndpoints.verifyOtp,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(otpRequest.toJson())
   
      );
      log(response.body);
      if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token = responseData["auth_token"];
       final String revoAccessToken = responseData["revo_access_token"];
       
       final String revoLambdaToken = responseData["revo_lambda_token"];
      final String userName = responseData["user"]["name"];
      final int userId = responseData["user"]["id"];
      
      final String role = responseData["user"]["role"];
          final String? profileImage = responseData["user"]["profile_photo_url"];          
          final String? coverPhotoUrl = responseData["user"]["cover_photo_url"];       
          final String email = responseData["user"]["email"];
     final String phone = responseData["user"]["phone"];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
         await prefs.setString('revo_access_token', revoAccessToken);
         await prefs.setString('revo_lambda_token', revoLambdaToken);
      await prefs.setString('userName', userName);
      await prefs.setString('role', role);
      await prefs.setInt('uid', userId);
      await prefs.setString('profile_photo_url', profileImage ?? '');
      await prefs.setString('cover_photo_url', coverPhotoUrl ?? '');
      await prefs.setString('email', email);
       await prefs.setString('phone', phone);
    
    final storedToken = prefs.getString('token');
    log("token fetchedddd$storedToken");
    // await  UserController().loadUserSession();
      await  userController.loadUserSession();
  //     final UserController userController = Get.put(UserController());

  // final DiscoverViewModel _viewModel = Get.put(DiscoverViewModel());
 Get.toNamed(RouteName.homeScreen,);
        // return OTPResponseModel.fromJson(jsonDecode(response.body));
        
        return OTPResponseModel(success: true, message: "OTP verified Successfully.");
      } else {
        return OTPResponseModel(success: false, message: "OTP verification failed.");
      }
    } catch (e) {
      return OTPResponseModel(success: false, message: "Network error.");
    }
  }
    Future<int> SendOTP(String email) async {
    try {
      final response = await apiClient.sendOtp(
        url: ApiEndpoints.sendOtp,
        headers: {"Content-Type": "application/json"},
   body:  jsonEncode({
  "email": email,
})
);
      return response.statusCode;
   
    } catch (e) {
   Utils.showCustomSnackBar("Error","Failed to send OTP: $e ", ContentType.failure);
      return 0;
      // return OTPResponseModel(success: false, message: "Network error.");
    }
  }
  Future<void> loginUser(Map<String, String> credentials) async {

    try {
      final response = await apiClient.loginUser(
        ApiEndpoints.login,
        body: credentials,
        headers: {"Content-Type": "application/json"},
      );
   
  // final UserController userController = Get.put(UserController());
       
      // return UserRegistrationResponse.fromJson(response);
    } catch (e) {
      Utils.showCustomSnackBar("Login Failed", Utils.mapErrorMessage(e.toString()), ContentType.failure);
      throw Exception("Login Failed: $e");
    }
  }
}
