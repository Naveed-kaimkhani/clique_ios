import 'dart:async';
import 'package:clique/data/models/signup_params.dart';
import 'package:clique/view_model/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
class OTPController extends GetxController {
  final otpController = TextEditingController();
  final _secondsRemaining = 96.obs;
  final _isResendActive = false.obs;
  Timer? _timer;

  int get secondsRemaining => _secondsRemaining.value;
  bool get isResendActive => _isResendActive.value;

  @override
  void onInit() {
    super.onInit();
    // startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining.value > 0) {
        _secondsRemaining.value--;
      } else {
        _isResendActive.value = true;
        timer.cancel();
      }
    });
  }

  void resendCode() {
    _secondsRemaining.value = 96;
    _isResendActive.value = false;
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpController.dispose();
    super.onClose();
  }
}

class OTPScreen extends StatelessWidget {
  final OTPController otpController = Get.put(OTPController());
  
  final OTPViewModel otpViewModel = Get.put(OTPViewModel());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpControllerField = TextEditingController();
  final SignupParams signupParams = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: ()=>Get.back(),
          child: Icon(Icons.arrow_back, color: Colors.black)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Verification code", style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Enter OTP sent to your email", style: TextStyle(color: Colors.grey, fontSize: 16)),
            SizedBox(height: 20),

            SizedBox(height: 20),
            /// OTP Input
            PinCodeTextField(
              length: 6,
              controller: otpControllerField,
              obscureText: false,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 50,
                fieldWidth: 40,
                inactiveFillColor: Colors.grey.shade300,
                // inactiveColor: Colors.grey.shade700,
                
                inactiveColor: Colors.white,
                selectedFillColor: Color(0xFF161622),
                selectedColor: Colors.blueAccent,
                activeFillColor: Colors.white,
                activeColor: Colors.black,
              ),
              textStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              animationDuration: Duration(milliseconds: 300),
              enableActiveFill: true,
              appContext: context,
            ),

            SizedBox(height: 20),

            /// Confirm Button with Gradient
            Obx(() {
              return GestureDetector(
                onTap: () {
                  otpViewModel.verifyOTP(signupParams.email, otpControllerField.text.trim());

                },
                child: Container(
                  decoration: BoxDecoration(
                    // gradient: AppColors.appGradientColors,
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  child: Center(
                    child: otpViewModel.isLoading.value
                        ? CircularProgressIndicator.adaptive(backgroundColor: Colors.white)
                        : Text(
                            "Confirm",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              );
            }),

            SizedBox(height: 20),

            // /// Response Message
            // Obx(() => Text(
            //       otpViewModel.otpResponse.value,
            //       style: TextStyle(color: Colors.red, fontSize: 16),
            //       textAlign: TextAlign.center,
            //     )),
          ],
        ),
      ),
    );
  }
}
