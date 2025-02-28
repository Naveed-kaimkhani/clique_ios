import 'package:clique/components/index.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/core/api/api_response.dart';
import 'package:clique/data/models/user_model.dart';
import 'package:clique/data/models/signup_params.dart';
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
          labelText: "Name",
          controller: nameController,
        ),
        SizedBox(height: Get.height * 0.02),
        CustomTextField(
          labelText: "Email",
          controller: emailController,
        ),
        SizedBox(height: Get.height * 0.02),
        CustomTextField(
          labelText: "Phone Number",
          controller: phoneNumberController,
        ),
        SizedBox(height: Get.height * 0.02),
        CustomTextField(
          labelText: "Password",
          controller: passwordController,
          isPassword: true,
        ),
        SizedBox(height: Get.height * 0.02),
        CustomTextField(
          labelText: "Confirm Password",
          controller: confirmPasswordController,
          isPassword: true,
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
                    if (!isChecked.value) {
                      Get.snackbar(
                        'Error',
                        'Please accept terms and conditions',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }
                    SignupParams request = SignupParams(
                      name: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      confirmPassword: confirmPasswordController.text,
                      role: "user",
                    );
                    authViewModel.registerUser(request);
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
              Obx(() {
                final status = authViewModel.signupResponse.value.status;
                final message = authViewModel.signupResponse.value.message;
                final data = authViewModel.signupResponse.value.data;

                if (status == Status.ERROR) {
                  return Text("Error: $message",
                      style: TextStyle(color: Colors.red));
                } else if (status == Status.COMPLETED) {
                  return Text("Success: ${data?.message}",
                      style: TextStyle(color: Colors.green));
                }
                return SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool isPassword;
  final TextEditingController controller;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: AppColors.appGradientColors.withOpacity(0.3),
          ),
          padding: EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(color: Colors.black),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: isPassword ? Icon(Icons.visibility_off) : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
