import 'package:clique/components/custom_textfield.dart';
import 'package:clique/components/gradient_text.dart';
import 'package:clique/constants/index.dart';
import 'package:clique/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final RxBool isChecked = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthViewModel authViewModel = Get.put(AuthViewModel());

final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
  bool validateFields() {
    if (emailController.text.isEmpty) {
      Get.snackbar("Email is required", "Please enter your email");
      return false;
    }
    if (!emailController.text.endsWith('@gmail.com') || !emailController.text.endsWith('@yahoo.com') || !emailController.text.endsWith('@outlook.com') || !emailController.text.endsWith('@icloud.com') || !emailController.text.endsWith('@hotmail.com') || !emailController.text.endsWith('@live.com') ) {
      Get.snackbar("Invalid email", "Please enter a valid email address");
      return false;
    }
    
 
    if (passwordController.text.isEmpty) {
      Get.snackbar("Password is required", "Please enter your password");
      return false;
    }
    if (!passwordRegex.hasMatch(passwordController.text)) {
  Get.snackbar("Invalid Password", "Password must be at least 8 characters long and include at least one letter, one number, and one special character.");
  return false;
}
    // if (passwordController.text.length < 8) {
    //   Get.snackbar("Password is too short", "Password must be at least 8 characters long");
    //   return false;
    // }
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

  Widget _buildTextFields() {
    return Column(
      children: [
        CustomTextField(
          hintText: 'Email Address',
          controller: emailController,
        ),
        SizedBox(height: Get.height * 0.015),
        CustomTextField(
          hintText: 'Password',
          // isPassword: true,
          controller: passwordController,
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
                icon: Image.asset("assets/png/google.png", width: Get.width * 0.05, height: Get.width * 0.05),
                label: "Google",
                borderColor: Colors.red,
                isGradientText: true,
              ),
            ),
            SizedBox(width: Get.width * 0.02),
            Expanded(
              child: _socialButton(
                icon: Icon(Icons.apple, color: Colors.black),
                label: "Apple",
                borderColor: Colors.black,
                textColor: Colors.black,
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
    bool isGradientText = false,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: borderColor),
      ),
      onPressed: () {},
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
              SizedBox(height: Get.height * 0.02),
              _buildSocialButtons(),
              SizedBox(height: Get.height * 0.03),
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
                      authViewModel.loginUser(emailController.text, passwordController.text);
                    }
                  },
                  child: const Text('Login', style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(height: Get.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ",
                      style: TextStyle(color: Colors.black)),
                  GestureDetector(
                    onTap: () => Get.toNamed("/login"),
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

// class CustomTextField extends StatelessWidget {
//   final String labelText;
//   final bool isPassword;
//   final TextEditingController controller;

//   const CustomTextField({
//     Key? key,
//     required this.labelText,
//     required this.controller,
//     this.isPassword = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             gradient: AppColors.appGradientColors.withOpacity(0.3),
//           ),
//           padding: EdgeInsets.all(2),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: TextField(
//               controller: controller,
//               obscureText: isPassword,
//               decoration: InputDecoration(
//                 labelText: labelText,
//                 labelStyle: TextStyle(color: Colors.black),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(
//                   horizontal: Get.width * 0.04,
//                   vertical: Get.height * 0.015,
//                 ),
//                 suffixIcon: isPassword ? Icon(Icons.visibility_off) : null,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
