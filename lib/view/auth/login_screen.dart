import 'package:clique/components/auth_button.dart';
import 'package:clique/components/custom_textfield.dart';
import 'package:clique/components/gradient_text.dart';
import 'package:clique/constants/index.dart';
import 'package:clique/data/models/signup_params.dart';
import 'package:clique/utils/utils.dart';
import 'package:clique/view_model/auth_viewmodel.dart';
import 'package:clique/view_model/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:google_sign_in/google_sign_in.dart';
class LoginScreen extends StatelessWidget {
  final RxBool isChecked = false.obs;
  final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();

  final AuthViewModel authViewModel = Get.put(AuthViewModel());

  // final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@(gmail\.com|yahoo\.com|outlook\.com|icloud\.com|hotmail\.com|live\.com)$');

  final OTPViewModel otpViewModel = Get.put(OTPViewModel());
 final GoogleSignIn _googleSignIn = GoogleSignIn(
    // scopes: ['email', 'profile'], // Request email and profile details
  );

  bool validateFields() {
    if (emailController.text.isEmpty) {
     Utils.showCustomSnackBar(
        'Email Required',
        'Please enter your email',
        ContentType.warning
      );
      return false;
    }
 
    if (!emailRegex.hasMatch(emailController.text)) {
  Utils.showCustomSnackBar(
    'Invalid Email',
    'Please enter a valid email address',
    ContentType.failure
  );
  return false;
}
    return true;
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            AppImages.appLogo, 
            height: MediaQuery.of(context).size.height * 0.26,
          ),
        ),
        // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        const Text(
          'Welcome Back..!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Enter your personal details to access an account.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // Fetch user details
        final String name = googleUser.displayName ?? "Unknown";
        final String email = googleUser.email;
        // final String phone = googleUser.
        final String profilePicture = googleUser.photoUrl ?? "";




        // Optionally, you can send these details to your API
        final SignupParams request = SignupParams(
          name: name,
          email: email,
          phone: "", // You can leave this empty or ask the user to fill it
          role: "",
        );
            int statusCode = await otpViewModel.sendOTP(request.email);

    if (statusCode == 200) {
      Get.toNamed(RouteName.oTPScreen, arguments: request);
    } else {
      Utils.showCustomSnackBar("Error", "Failed to send OTP", ContentType.failure);
    }
  } 
      }
     catch (e) {
        Utils.showCustomSnackBar("Error","Google Sign-In Failed", ContentType.failure);
      // _showValidationError("Google Sign-In Failed", "An error occurred during Google Sign-In.");
    }
  }
  Widget _buildTextFields() {
    return Column(
      children: [
        CustomTextField(
          hintText: 'Email Address',
          controller: emailController,
        ),
        SizedBox(height: Get.height * 0.015),
        // CustomTextField(
        //   hintText: 'Password',
        //   // isPassword: true,
        //         obscureText: true,
        //   controller: passwordController,
        // ),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Column(
      children: [
        Row(
          children: [
            Obx(() => Checkbox(
              activeColor: AppColors.black,
              value: isChecked.value,
              onChanged: (value) => isChecked.value = value ?? false,
            )),
            const Text('I agree with the terms & conditions')
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: Text('Or', style: TextStyle(color: Colors.grey)),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _socialButton(
                icon: Image.asset("assets/png/google.png", width: Get.width * 0.05, height: Get.width * 0.05),
                label: "Google",
                borderColor: Colors.red,
                isGradientText: true,
                onPressed: () => _handleGoogleSignIn(),
              ),
            ),
            SizedBox(width: Get.width * 0.02),
            Expanded(
              child: _socialButton(
                icon: Icon(Icons.apple, color: Colors.black),
                label: "Apple",
                borderColor: Colors.black,
                textColor: Colors.black,
                onPressed: ()=>_handleGoogleSignIn()
              ),
            ),
          ],
        ),
      ],
    );
  }
Widget _socialButton({
  required Widget icon,
  required String label,
  required Color borderColor,
  required VoidCallback onPressed,
  Color textColor = Colors.red,
  bool isGradientText = false,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      side: BorderSide(color: borderColor),
    ),
    onPressed: onPressed,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        SizedBox(width: Get.width * 0.02),
        isGradientText
            ? GradientText(label, gradient: AppColors.appGradientColors, fontSize: 14)
            : Text(label, style: TextStyle(color: textColor)),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: Get.height * 0.03),
              _buildTextFields(),
              // SizedBox(height: Get.height * 0.02),
              // _buildSocialButtons(),
               Row(
          children: [
            Obx(() => Checkbox(
              activeColor: AppColors.black,
              value: isChecked.value,
              onChanged: (value) => isChecked.value = value ?? false,
            )),
            const Text('I agree with the terms & conditions')
          ],
        ),
              SizedBox(height: Get.height * 0.02),
              AuthButton(
                buttonText: 'Login',
                isLoading: authViewModel.isLoading,
                onPressed: ()async {
  if (true) {
  authViewModel.isLoading.value = true;
  try {
    final SignupParams request = SignupParams(
      name: "",
      email: "naveedkaimkhami@gmail.com",
      phone: "",
      role: "",
    );

    int statusCode = await otpViewModel.sendOTP(request.email);
    
  authViewModel.isLoading.value = false;
    if (statusCode == 200) {
      Get.toNamed(RouteName.oTPScreen, arguments: request);
    } else {
      Utils.showCustomSnackBar("Error", "Failed to send OTP", ContentType.failure);
    }
  } catch (error) {
    Utils.showCustomSnackBar("Error", "Something went wrong", ContentType.failure);
  } finally {
    otpViewModel.isLoading.value = false;
  }
}
                  
                },
              ),
              SizedBox(height: Get.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ",
                      style: TextStyle(color: Colors.black)),
                  GestureDetector(
                    onTap: () => Get.toNamed(RouteName.signupScreen),
                    child: GradientText("Sign Up",
                        gradient: AppColors.appGradientColors, fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
