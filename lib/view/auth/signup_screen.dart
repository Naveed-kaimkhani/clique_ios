

import 'dart:developer';

import 'package:clique/components/auth_button.dart';
import 'package:clique/components/custom_textfield.dart';
import 'package:clique/components/index.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/data/models/signup_params.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clique/utils/utils.dart';

import '../../view_model/auth_viewmodel.dart';

class SignupScreen extends StatelessWidget {
  // Controllers
  final AuthViewModel _authViewModel = Get.put(AuthViewModel());
  final RxBool _isChecked = false.obs;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  // Constants
  static const List<String> _validEmailDomains = ['@gmail.com', '@yahoo.com', '@icloud.com'];
  static const int _requiredPhoneLength = 11;
  static const int _minPasswordLength = 8;
  
  final _passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
@override
void dispose() {
  _nameController.dispose();
  _emailController.dispose();
  _passwordController.dispose();
  _confirmPasswordController.dispose();
  _phoneNumberController.dispose();
}
  bool _validateFields() {
    if (!_isChecked.value) {
      _showValidationError("Terms & Conditions", "Please agree to the terms & conditions");
      return false;
    }

    if (_nameController.text.isEmpty) {
      _showValidationError("Name is required", "Please enter your name");
      return false;
    }

    if (_emailController.text.isEmpty) {
      _showValidationError("Email is required", "Please enter your email");
      return false;
    }

    if (!_isValidEmail(_emailController.text)) {
      _showValidationError("Invalid email", 
        "Please enter a valid email address (@gmail.com, @yahoo.com or @icloud.com)");
      return false;
    }

    if (_phoneNumberController.text.isEmpty) {
      _showValidationError("Phone number is required", "Please enter your phone number");
      return false;
    }

    if (_phoneNumberController.text.length != _requiredPhoneLength) {
      _showValidationError("Invalid phone number", "Phone number must be 11 digits long");
      return false;
    }

    if (!_validatePassword()) return false;

    return true;
  }

  bool _validatePassword() {
    if (_passwordController.text.isEmpty) {
      _showValidationError("Password is required", "Please enter your password");
      return false;
    }

    if (_passwordController.text.length < _minPasswordLength) {
      _showValidationError("Password is too short", 
        "Password must be at least 8 characters long");
      return false;
    }

    if (_confirmPasswordController.text.isEmpty) {
      _showValidationError("Confirm password is required", "Please confirm your password");
      return false;
    }

    if (!_passwordRegex.hasMatch(_passwordController.text)) {
      _showValidationError("Invalid Password", 
        "Password must include at least one letter, one number, and one special character.");
      return false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showValidationError("Passwords don't match", 
        "Password and confirm password must match");
      return false;
    }

    return true;
  }

  void _showValidationError(String title, String message) {
    Utils.showCustomSnackBar(title, message, ContentType.warning);
  }

  bool _isValidEmail(String email) {
    return _validEmailDomains.any((domain) => email.endsWith(domain));
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(
          text: "Create Account",
          fontSize: Get.width * 0.07,
        ),
        LabelText(
          text: "Enter your personal details to create an account.",
          fontSize: Get.width * 0.04,
        )
      ],
    );
  }

  Widget _buildTextFields() {
    return Column(
      children: [
        CustomTextField(
          hintText: "Name",
          controller: _nameController,
        ),
        SizedBox(height: Get.height * 0.02),
        CustomTextField(
          hintText: "Email",
          controller: _emailController,
        ),
        SizedBox(height: Get.height * 0.02),
        CustomTextField(
          hintText: "Phone Number",
          controller: _phoneNumberController,
        ),
        SizedBox(height: Get.height * 0.02),
        CustomTextField(
          hintText: "Password",
          controller: _passwordController,
          obscureText: true,
        ),
        SizedBox(height: Get.height * 0.02),
        CustomTextField(
          hintText: "Confirm Password",
          controller: _confirmPasswordController,
          obscureText: true,
        ),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Column(
      children: [
        _buildTermsAndConditions(),
        const SizedBox(height: 10),
        const Center(
          child: Text('Or', style: TextStyle(color: Colors.grey)),
        ),
        const SizedBox(height: 10),
        _buildSocialLoginButtons(),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        Obx(() => Checkbox(
          activeColor: AppColors.black,
          value: _isChecked.value,
          onChanged: (value) => _isChecked.value = value ?? false,
        )),
        const Text('I agree with the terms & conditions')
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _socialButton(
            icon: Image.asset(
              "assets/png/google.png",
              width: Get.width * 0.04,
              height: Get.width * 0.04
            ),
            label: "Google",
            borderColor: Colors.red,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _socialButton(
            icon: const Icon(Icons.apple, color: Colors.black),
            label: "Apple",
            borderColor: Colors.black,
            textColor: Colors.black,
            onPressed: () {},
          ),
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
              ? GradientText(
                  label,
                  gradient: AppColors.appGradientColors,
                  fontSize: 14
                )
              : Text(label, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }

  void _handleSignup() {
          log("klsdjfsdflksdkjfsdf");
        final SignupParams request = SignupParams(
        name:"_nameController.text",
        email: "a22d1@gmail.com",
        password: "nav41458@Kk",
        phone: "3428228823",
        confirmPassword: "nav41458@Kk",
        role: "user",
      );
      
      _authViewModel.registerUser(request, _nameController.text)
        .then((_) => _authViewModel.isLoading.value = false)
        .catchError((_) => _authViewModel.isLoading.value = false);
    
    
    
    // if (_validateFields()) {
    //   _authViewModel.isLoading.value = true;
      
    //   final SignupParams request = SignupParams(
    //     name: _nameController.text,
    //     email: _emailController.text,
    //     password: _passwordController.text,
    //     phone: _phoneNumberController.text,
    //     confirmPassword: _confirmPasswordController.text,
    //     role: "user",
    //   );
        
    //   _authViewModel.registerUser(request, _nameController.text)
    //     .then((_) => _authViewModel.isLoading.value = false)
    //     .catchError((_) => _authViewModel.isLoading.value = false);
    // }
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
              AuthButton(
                buttonText: 'SignUp',
                isLoading: _authViewModel.isLoading,
                onPressed: _handleSignup,
              ),
              SizedBox(height: Get.height * 0.02),
              _buildLoginLink(),
              SizedBox(height: Get.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(color: Colors.black)
        ),
        GestureDetector(
          onTap: () => Get.toNamed(RouteName.loginScreen),
          child: GradientText(
            "Login",
            gradient: AppColors.appGradientColors,
            fontSize: 15
          ),
        ),
      ],
    );
  }
}