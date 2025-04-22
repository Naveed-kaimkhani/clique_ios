import 'dart:developer';

import 'package:clique/components/auth_button.dart';
import 'package:clique/components/custom_textfield.dart';
import 'package:clique/components/index.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/data/models/signup_params.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:clique/view_model/otp_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clique/utils/utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../view_model/auth_viewmodel.dart';

class SignupScreen extends StatelessWidget {
  final AuthViewModel _authViewModel = Get.put(AuthViewModel());
  final RxBool _isChecked = false.obs;
  final RxString _selectedRole = "user".obs; // Add this for role selection
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();


  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const List<String> _validEmailDomains = [
    '@gmail.com',
    '@yahoo.com',
    '@icloud.com'
  ];

  final OTPViewModel otpViewModel = Get.put(OTPViewModel());
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    // _passwordController.dispose();
    // _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
  }

  bool _validateFields() {
    if (!_isChecked.value) {
      _showValidationError(
          "Terms & Conditions", "Please agree to the terms & conditions");
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
        if (_phoneNumberController.text.isNotEmpty && _phoneNumberController.text.length>10) {
      _showValidationError("Warning", "Phone Number must be 10 digits");
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
        // CustomTextField(
        //   keyboardType: TextInputType.number,
        //   hintText: "Phone Number",
        //   controller: _phoneNumberController,
        // ),
     
        SizedBox(height: Get.height * 0.02),
        Align(
          alignment: Alignment.centerLeft,
          child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: "user",
                    groupValue: _selectedRole.value,
                    onChanged: (value) =>
                        _selectedRole.value = value.toString(),
                    activeColor: AppColors.appColor,
                  ),
                  const Text("User"),
                  const SizedBox(width: 20),
                  Radio(
                    value: "influencer",
                    groupValue: _selectedRole.value,
                    onChanged: (value) =>
                        _selectedRole.value = value.toString(),
                    activeColor: AppColors.appColor,
                  ),
                  const Text("Influencer"),
                ],
              )),
        )
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
        // const Text('I agree with the terms & conditions'),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black, fontSize: 14), // base style
            children: [
              TextSpan(text: 'I agree with the '),
              TextSpan(
                text: 'terms & conditions',
                style: TextStyle(
                  color: AppColors.appColor,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.toNamed(RouteName.termsAndConditionsScreen);
                  },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialButton(
          icon: Image.asset(
            "assets/png/google.png",
            width: Get.width * 0.04,
            height: Get.height * 0.04,
          ),
          label: "Google",
          borderColor: Colors.red,
          onPressed: _handleGoogleSignIn,
        ),
        const SizedBox(width: 20),
        SizedBox(
          width: 155,
          height: 43,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30), // ← your desired radius
            child: SignInWithAppleButton(
              text: "Apple",
              onPressed: _handleAppleSignIn,
            ),
          ),
        )
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



Future<void> _handleAppleSignIn() async {
  if (!_isChecked.value) {
    _showValidationError(
        "Terms & Conditions", "Please agree to the terms & conditions");
    return;
  }

  _authViewModel.isLoading.value = true;

  try {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    // Try to get from Apple
    String? email = appleCredential.email;
    String? name =
        "${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}".trim();

    // If email is available, save it
    if (email != null) {
      await _secureStorage.write(key: 'email', value: email);
    } else {
      // Otherwise, retrieve from local storage
      email = await _secureStorage.read(key: 'email');
    }

    if (name.isNotEmpty) {
      await _secureStorage.write(key: 'fullName', value: name);
    } else {
      name = await _secureStorage.read(key: 'fullName') ?? "Apple User";
    }

    // If still no email, show error and exit
    if (email == null) {
      _authViewModel.isLoading.value = false;
      _showValidationError(
        "Account Exists",
        "Apple ID already registered. Please sign in or clear app data.",
      );
      return;
    }

  _authViewModel.isLoading.value = true;
    // Populate fields for consistency
    _nameController.text = name;
    _emailController.text = email;

    final SignupParams request = SignupParams(
      name: name,
      email: email,
      phone: "", // Optional
      role: _selectedRole.value,
    );

    _authViewModel.registerUser(request, name).then((_) {
      _authViewModel.isLoading.value = false;
    }).catchError((e) {
      _authViewModel.isLoading.value = false;
      _showValidationError("Signup Error", e.toString());
    });
  } catch (e) {
    _authViewModel.isLoading.value = false;
    // Get.snackbar("Error", e.toString());
  }
}

//  Future<void> _handleAppleSignIn() async {
//     if (!_isChecked.value) {
//       _showValidationError(
//           "Terms & Conditions", "Please agree to the terms & conditions");
//       return;
//     }

//     try {
//       final appleCredential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//       );

//       // Extract full name and email from the Apple Sign-In response
//       final String name =
//           "${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}"
//               .trim();
//       final String? email = appleCredential.email;

//       // Check if email is null (second login or user opted not to share email)
//       if (email == null) {
//  _showValidationError(
//   "Account Exists",
//   "Apple ID already registered. Please sign in or clear app data.",
// );


//         return;
//       }

//       // Populate fields
//       _nameController.text = name.isNotEmpty ? name : "Apple User";
//       _emailController.text = email;

//       // Prepare the request data to be sent to your backend
//       final SignupParams request = SignupParams(
//         name: name.isEmpty ? "Apple User" : name,
//         email: email,
//         phone: "", // Handle if needed
//         role: _selectedRole.value,
//       );

//       // Sending the request to your backend (uncomment and update according to your backend logic)
//       _authViewModel.registerUser(request, name).then((_) {
//         _authViewModel.isLoading.value = false;
//         // Handle success response, maybe navigate to a different screen
//       }).catchError((e) {
//         _authViewModel.isLoading.value = false;
//         _showValidationError("Signup Error", e.toString());
//       });
//     } catch (e) {
//       // _showValidationError("Apple Sign-In Failed", e.toString());
//       Get.snackbar("errr", e.toString());
//     }
//   } 
    

  Future<void> _handleGoogleSignIn() async {
    if (!_isChecked.value) {
      _showValidationError(
          "Terms & Conditions", "Please agree to the terms & conditions");
      return;
    } else {
      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser != null) {
          // Fetch user details
          final String name = googleUser.displayName ?? "Unknown";
          final String email = googleUser.email;

          // Populate the form fields with Google details
          _nameController.text = name;
          _emailController.text = email;

          // Optionally, you can send these details to your API
          final SignupParams request = SignupParams(
            name: name,
            email: email,
            phone: "", // You can leave this empty or ask the user to fill it
            role: _selectedRole.value,
          );
          // Call your signup API
          _authViewModel
              .registerUser(request, name)
              .then((_) => _authViewModel.isLoading.value = false)
              .catchError((_) => _authViewModel.isLoading.value = false);
        }
      } catch (e) {
        _showValidationError("Google Sign-In Failed",
            "An error occurred during Google Sign-In.");
      }
    }
  }

  void _handleSignup() async {
    if (_validateFields()) {
      _authViewModel.isLoading.value = true;
      final SignupParams request = SignupParams(
        name: _nameController.text,
        email: _emailController.text,
        // password:"",
        phone: "",
        // confirmPassword:"",
        role: _selectedRole.value,
      );

      // Get.toNamed(RouteName.oTPScreen, arguments: request);
      _authViewModel
          .registerUser(request, _nameController.text)
          .then((_) => _authViewModel.isLoading.value = false)
          .catchError((_) => _authViewModel.isLoading.value = false);
    }
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
              Center(
                child: AuthButton(
                  buttonText: 'SignUp',
                  isLoading: _authViewModel.isLoading,
                  onPressed: _handleSignup,
                ),
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
        const Text("Already have an account? ",
            style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () => Get.toNamed(RouteName.loginScreen),
          child: GradientText("Login",
              gradient: AppColors.appGradientColors, fontSize: 15),
        ),
      ],
    );
  }
}
