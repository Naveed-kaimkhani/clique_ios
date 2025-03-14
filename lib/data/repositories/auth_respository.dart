
import 'dart:convert';
import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clique/data/models/signup_params.dart';
import 'package:clique/models/otp_model.dart';
import 'package:clique/utils/utils.dart';
import 'package:get/get.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';

class AuthRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

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
      if (response.statusCode == 200) {
        log("verfifieddd");
        // return OTPResponseModel.fromJson(jsonDecode(response.body));
        
        return OTPResponseModel(success: true, message: "OTP verified Successfully.");
      } else {
        return OTPResponseModel(success: false, message: "OTP verification failed.");
      }
    } catch (e) {
      return OTPResponseModel(success: false, message: "Network error.");
    }
  }
    Future<int> SendOTP(String phone) async {
    try {
      final response = await apiClient.sendOtp(
        url: ApiEndpoints.sendOtp,
        headers: {"Content-Type": "application/json"},
   body:  jsonEncode({
  "phone": phone,
})
);
      log(response.statusCode.toString());
      log(response.body);
      return response.statusCode;
   
    } catch (e) {
   Utils.showCustomSnackBar("Error","Failed to send OTP: $e ", ContentType.failure);
      return 0;
      // return OTPResponseModel(success: false, message: "Network error.");
    }
  }
  Future<void> loginUser(Map<String, String> credentials) async {
    log("in loginuser");
    log(credentials.toString());
    try {
      final response = await apiClient.loginUser(
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
