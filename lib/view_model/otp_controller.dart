import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clique/constants/index.dart';
import 'package:clique/data/repositories/auth_respository.dart';
import 'package:clique/utils/utils.dart';
import 'package:get/get.dart';
import '../models/otp_model.dart';

class OTPViewModel extends GetxController {
  var isLoading = false.obs;
  var otpResponse = "".obs;

 
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  Future<void> verifyOTP(String phone, String otp) async {
    isLoading.value = true;
    OTPRequestModel requestModel = OTPRequestModel(phone:phone , otp: otp);

    OTPResponseModel response = await _authRepo.verifyOTP(requestModel);
    otpResponse.value = response.message;

    if (response.success) {
     Utils.showCustomSnackBar("Success",  response.message, ContentType.success);
      Get.offAllNamed(RouteName.loginScreen);
    } else {
         Utils.showCustomSnackBar("Error",  response.message, ContentType.failure);
  
    }
    
    isLoading.value = false;
  }
    Future<int> sendOTP(String phone) async {
    int response = await _authRepo.SendOTP(phone);
  return response;
    
    
  }
}
