import 'package:clique/components/custom_textfield.dart';
import 'package:clique/components/index.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/core/api/api_response.dart';
import 'package:clique/data/models/signup_params.dart';
import 'package:clique/view/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../view_model/auth_viewmodel.dart';

class SignupScreen extends StatelessWidget {
  final AuthViewModel authViewModel = Get.put(AuthViewModel());
  final RxBool isChecked = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

  bool validateFields() {
       if (!isChecked.value) {
                      Get.snackbar("Terms & Conditions", "Please agree to the terms & conditions");
                      return false;
                    }
    if (nameController.text.isEmpty) {
      Get.snackbar("Name is required", "Please enter your name");
      return false;
    }

    if (emailController.text.isEmpty) {
      Get.snackbar("Email is required", "Please enter your email");
      return false;
    }

    if (!emailController.text.endsWith('@gmail.com') && 
        !emailController.text.endsWith('@yahoo.com') && 
        !emailController.text.endsWith('@icloud.com')) {
      Get.snackbar("Invalid email", "Please enter a valid email address (@gmail.com, @yahoo.com or @icloud.com)");
      return false;
    }

    if (phoneNumberController.text.isEmpty) {
      Get.snackbar("Phone number is required", "Please enter your phone number");
      return false;
    }

    if (phoneNumberController.text.length != 11) {
      Get.snackbar("Invalid phone number", "Phone number must be 11 digits long");
      return false;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar("Password is required", "Please enter your password");
      return false;
    }

    // if (passwordController.text.length < 8) {
    //   Get.snackbar("Password is too short", "Password must be at least 8 characters long");
    //   return false;
    // }
if (!passwordRegex.hasMatch(passwordController.text)) {
  Get.snackbar("Invalid Password", "Password must be at least 8 characters long and include at least one letter, one number, and one special character.");
  return false;
}
    if (confirmPasswordController.text.isEmpty) {
      Get.snackbar("Confirm password is required", "Please confirm your password");
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Passwords don't match", "Password and confirm password must match");
      return false;
    }

    return true;
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          "Create Account",
          gradient: AppColors.appGradientColors,
          fontSize: Get.width * 0.07,
        ),
        GradientText(
          "Enter your personal details to create an account.",
          gradient: AppColors.appGradientColors,
          fontSize: Get.width * 0.04,
        ),
      ],
    );
  }

  Widget _buildTextFields() {
    return Column(
      children: [
        CustomTextField(
          hintText: "Name",
          controller: nameController,
        ),
        SizedBox(height: Get.height * 0.02),
        CustomTextField(
          hintText: "Email",
          controller: emailController,
        ),
        SizedBox(height: Get.height * 0.02),
        CustomTextField(
          hintText: "Phone Number",
          controller: phoneNumberController,
        ),
        SizedBox(height: Get.height * 0.02),
        CustomTextField(
          hintText: "Password",
          controller: passwordController,
          // isPassword: true,
        
        ),
        SizedBox(height: Get.height * 0.02),
        CustomTextField(
          hintText: "Confirm Password",
          controller: confirmPasswordController,
          // isPassword: true,
        ),
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
                icon: Image.asset("assets/png/google.png", width: Get.width * 0.04, height: Get.width * 0.04),
                label: "Google",
                borderColor: Colors.red,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded( 
              child: _socialButton(
                icon: Icon(Icons.apple, color: Colors.black),
                label: "Apple",
                borderColor: Colors.black,
                textColor: Colors.black,
                onPressed: () {},
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
    Color textColor = Colors.red,
    required VoidCallback onPressed,
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
          const SizedBox(width: 10),
          label == "Google"
              ? GradientText(label,
                  gradient: AppColors.appGradientColors, fontSize: 14)
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
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.05,
            vertical: Get.height * 0.08,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: Get.height * 0.03),
              _buildTextFields(),
              SizedBox(height: Get.height * 0.02),
              _buildSocialButtons(),
              SizedBox(height: Get.height * 0.02),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: Get.height * 0.02,
                    ),
                  ),
                  onPressed: () {
                 
                    if (validateFields()) {
                      // SignupParams request = SignupParams(
                      //   name: nameController.text,
                      //   email: emailController.text,
                      //   password: passwordController.text,
                      //   phone: phoneNumberController.text,
                      //   confirmPassword: confirmPasswordController.text,
                      //   role: "user",
                      // );
                         SignupParams request = SignupParams(
                        name:" nameController.text",
                        email: "nav@gmail.com",
                        password: "11111111",
                        phone: "11111111112",
                        confirmPassword: "11111111112",
                        role: "user",
                      );
                      authViewModel.registerUser(request);
                    }
                  },
                  child: const Text('SignUp'),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ",
                      style: TextStyle(color: Colors.black)),
                  GestureDetector(
                    onTap: () => Get.toNamed("/login"),
                    child: GradientText("Login",
                        gradient: AppColors.appGradientColors, fontSize: 15),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              // Obx(() {
              //   final status = authViewModel.signupResponse.value.status;
              //   final message = authViewModel.signupResponse.value.message;
              //   final data = authViewModel.signupResponse.value.data;

              //   if (status == Status.ERROR) {
              //     return Text("Error: $message",
              //         style: TextStyle(color: Colors.red));
              //   } else if (status == Status.COMPLETED) {
              //     return Text("Success: ${data?.message}",
              //         style: TextStyle(color: Colors.green));
              //   }
              //   return SizedBox.shrink();
              // }),
            ],
          ),
        ),
      ),
    );
  }
}