import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:clique/components/auth_button.dart';
import 'package:clique/components/custom_textfield.dart';
import 'package:clique/components/profile_screen_appbar.dart';
import 'package:clique/constants/index.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/utils/utils.dart';
import 'package:clique/view/discover/appBar_backicon.dart';
import 'package:clique/view/home/home_screen.dart';
import 'package:clique/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  File? profilePhoto;
  File? coverPhoto;
  final UserController userController = Get.find<UserController>();
  final RxBool isLoading = false.obs; // Create isLoading as an RxBool

// final RxString _selectedRole = "user".obs;
  final RxBool isDeleting = false.obs;

  final AuthViewModel _authViewModel = Get.put(AuthViewModel());
  @override
  void initState() {
    super.initState();
    nameController.text = userController.userName.value;
    phoneController.text = userController.phone.value;
  }

  Future<void> pickImage(bool isProfile) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isProfile) {
          profilePhoto = File(pickedFile.path);
        } else {
          coverPhoto = File(pickedFile.path);
        }
      });
    }
  }

  bool _validateFields() {
    if (phoneController.text.isNotEmpty && phoneController.text.length > 10) {
      // _showValidationError("Name is required", "Please enter your name");
      Utils.showCustomSnackBar(
          "Warning", "Phone Number must be 10 digits", ContentType.warning);
      return false;
    }
    return true;
  }

  Future<void> updateUserProfile() async {
    if (_validateFields()) {
      isLoading.value = true; // Set isLoading to true when the API call starts

      try {
        var url = Uri.parse(
            'https://cactisocial.com/api-clique/public/api/v1/user/update?_method=PUT');
        var request = http.MultipartRequest('POST', url);

        request.headers.addAll({
          'Authorization': 'Bearer ${userController.token.value}',
          'Accept': 'application/json',
        });
        request.fields['name'] = nameController.text.isEmpty
            ? userController.userName.value
            : nameController.text;
        // request.fields['email'] = emailController.text;
        request.fields['phone'] = phoneController.text.isEmpty
            ? userController.phone.value
            : phoneController.text;
        // request.fields['role'] = _selectedRole.value;

        profilePhoto != null
            ? request.files.add(await http.MultipartFile.fromPath(
                'profile_photo', profilePhoto!.path))
            : userController.profilePhoto.value;
        coverPhoto != null
            ? request.files.add(await http.MultipartFile.fromPath(
                'cover_photo', coverPhoto!.path))
            : userController.coverPhoto.value;
        var response = await request.send();
      

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final Map<String, dynamic> responseData = jsonDecode(responseBody);

          final String userName = responseData["user"]["name"];
          final String? profileImage =
              responseData["user"]["profile_photo_url"];
          final String? coverPhotoUrl = responseData["user"]["cover_photo_url"];
          final String? phone = responseData["user"]["phone"];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userName', userName);
          await prefs.setString('profile_photo_url', profileImage ?? '');
          await prefs.setString('cover_photo_url', coverPhotoUrl ?? '');
          await prefs.setString('phone', phone ?? '');

          await userController.loadUserSession();
          Utils.showCustomSnackBar("Profile Updated",
              "Profile updated successfully", ContentType.success);

          Get.offAll(() => HomeScreen());
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        isLoading.value =
            false; // Set isLoading to false when the API call completes
      }
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please complete all fields')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWithBackIcon(
        title: "Edit Profile",
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                // Profile Photo Picker
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => pickImage(true),
                          child: ClipOval(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                image: profilePhoto != null
                                    ? DecorationImage(
                                        image: FileImage(profilePhoto!),
                                        fit: BoxFit.cover,
                                      )
                                    : (userController
                                            .profilePhoto.value.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(userController
                                                .profilePhoto.value),
                                            fit: BoxFit.cover,
                                          )
                                        : null),
                              ),
                              child: profilePhoto == null &&
                                      userController.profilePhoto.value.isEmpty
                                  ? Icon(
                                      Icons.camera_alt,
                                      size: 50,
                                      color: Colors.grey[600],
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Select Profile Photo"),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => pickImage(false),
                          child: ClipOval(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                image: coverPhoto != null
                                    ? DecorationImage(
                                        image: FileImage(coverPhoto!),
                                        fit: BoxFit.cover,
                                      )
                                    : (userController
                                            .coverPhoto.value.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(userController
                                                .coverPhoto.value),
                                            fit: BoxFit.cover,
                                          )
                                        : null),
                              ),
                              child: coverPhoto == null &&
                                      userController.coverPhoto.value.isEmpty
                                  ? Icon(
                                      Icons.camera_alt,
                                      size: 50,
                                      color: Colors.grey[600],
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Select Cover Photo"),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 60),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomTextField(
                      hintText: "Name",
                      controller: nameController,
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Phone Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phone",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomTextField(
                      keyboardType: TextInputType.number,
                      hintText: phoneController.text.isEmpty
                          ? "(123) 456-7890"
                          : phoneController.text,
                      controller: phoneController,
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.02),

                SizedBox(height: 50),

                // Update Profile Button
                AuthButton(
                  buttonText: 'Update Profile',
                  isLoading: isLoading, // Pass the isLoading observable
                  onPressed: updateUserProfile,
                ),

                SizedBox(height: 10),

                Container(
                  width: 160,
                  height: 50,
                  // margin: EdgeInsets.symmetric(horizontal: 40),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () => _showDeleteAccountDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[50],
                        foregroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: Colors.red.shade100, width: 1.5),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 14,
                            color: AppColors.appColor,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Delete Account",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.appColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 320),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Warning Icon
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_rounded,
                        size: 36,
                        color: AppColors.appColor,
                      ),
                    ),

                    SizedBox(height: 16),

                    // Title
                    Text(
                      "Delete Account?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.appColor,
                      ),
                    ),

                    SizedBox(height: 12),

                    // Description
                    Text(
                      "This will permanently delete your account and all associated data. This action cannot be undone.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    SizedBox(height: 24),

                    // Buttons Row
                    Row(
                      children: [
                        // Cancel Button
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 12),

                        // Delete Button with Loading
                        Expanded(
                          child: Obx(() => ElevatedButton(
                                onPressed: isDeleting.value
                                    ? null
                                    : () async {
                                        isDeleting.value = true;
                                        await _authViewModel.deleteUserAccount(
                                            userController.uid.value);
                                        Get.back(); // Instead of Navigator.pop
                                        Get.offAllNamed(RouteName.loginScreen);
                                        isDeleting.value = false;
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.appColor,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: isDeleting.value
                                    ? SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Text(
                                        "Delete",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
