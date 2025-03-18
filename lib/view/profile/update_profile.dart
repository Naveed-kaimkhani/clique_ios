// import 'dart:convert';
// import 'dart:io';
// import 'package:clique/components/custom_appbar.dart';
// import 'package:clique/constants/index.dart';
// import 'package:clique/controller/user_controller.dart';
// import 'package:clique/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// class UpdateProfileScreen extends StatefulWidget {
//   @override
//   _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
// }

// class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   File? profilePhoto;
//   File? coverPhoto;

//   final UserController userController = Get.find<UserController>();
//   // final String token = "YOUR_BEARER_TOKEN"; // Replace with actual token

//   Future<void> pickImage(bool isProfile) async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         if (isProfile) {
//           profilePhoto = File(pickedFile.path);
//         } else {
//           coverPhoto = File(pickedFile.path);
//         }
//       });
//     }
//   }

//   Future<void> updateUserProfile() async {
//     if (_formKey.currentState!.validate() && profilePhoto != null && coverPhoto != null) {
//       var url = Uri.parse('https://dev.moutfits.com/api/v1/user/update?_method=PUT');
//       var request = http.MultipartRequest('POST', url);

//       request.headers.addAll({
//         'Authorization': 'Bearer ${userController.token.value}',
//         'Accept': 'application/json',
//       });

//       request.fields['name'] = nameController.text;
//       request.fields['email'] = emailController.text;
//       request.fields['phone'] = phoneController.text;

//       request.files.add(await http.MultipartFile.fromPath('profile_photo', profilePhoto!.path));
//       request.files.add(await http.MultipartFile.fromPath('cover_photo', coverPhoto!.path));

//       var response = await request.send();
//     // InfluencerRepository repo = InfluencerRepository();
//     //   bool response = await repo.updateUserProfile(nameController.text, emailController.text, phoneController.text, profilePhoto!, coverPhoto!);
//       if (response.statusCode == 200) {
//            final responseBody = await response.stream.bytesToString();
//         final Map<String, dynamic> responseData = jsonDecode(responseBody);

//         // Extract values from the response
//         final String userName = responseData["user"]["name"];
//         final int userId = responseData["user"]["id"];
//         final String role = responseData["user"]["role"];
//         final String? profileImage = responseData["user"]["profile_photo_url"];
//         final String? coverPhotoUrl = responseData["user"]["cover_photo_url"];
//         final String email = responseData["user"]["email"];

//         // Print or use the extracted values
//         // print("Token: $token");
//         print("User Name: $userName");
//         print("User ID: $userId");
//         print("Role: $role");
//         print("Profile Image: $profileImage");
//         print("Cover Photo URL: $coverPhotoUrl");
//         print("Email: $email");

   
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('userName', userName);
//       await prefs.setString('role', role);
//       await prefs.setInt('uid', userId);
//       await prefs.setString('profile_photo_url', profileImage ?? '');
//       await prefs.setString('cover_photo_url', coverPhotoUrl ?? '');
//       await prefs.setString('email', email);
      
//       await  userController.loadUserSession();


// // await  userController.loadUserSession(); 
//   Utils.showCustomSnackBar("Profile Updated", "Profile updated successfully",ContentType.success );
   
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile')));
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please complete all fields')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar:CustomAppBar(title: 'Edit Profile', ),
//         body: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   // Profile Photo Picker
//                   GestureDetector(
//                     onTap: () => pickImage(true),
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundImage: profilePhoto != null ? FileImage(profilePhoto!) : null,
//                       child: profilePhoto == null ? Icon(Icons.camera_alt, size: 50) : null,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text("Tap to select Profile Photo"),
//                   SizedBox(height: 20),
      
//                   // Cover Photo Picker
//                   GestureDetector(
//                     onTap: () => pickImage(false),
//                     child: Container(
//                       height: 150,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         image: coverPhoto != null
//                             ? DecorationImage(image: FileImage(coverPhoto!), fit: BoxFit.cover)
//                             : null,
//                       ),
//                       child: coverPhoto == null ? Icon(Icons.camera_alt, size: 50) : null,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text("Tap to select Cover Photo"),
//                   SizedBox(height: 20),
      
//                   // Name Field
//                   TextFormField(
//                     controller: nameController,
//                     decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
//                     validator: (value) => value!.isEmpty ? 'Enter your name' : null,
//                   ),
//                   SizedBox(height: 10),
      
//                   // Email Field
//                   TextFormField(
//                     controller: emailController,
//                     decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) => value!.isEmpty ? 'Enter your email' : null,
//                   ),
//                   SizedBox(height: 10),
      
//                   // Phone Field
//                   TextFormField(
//                     controller: phoneController,
//                     decoration: InputDecoration(labelText: 'Phone', border: OutlineInputBorder()),
//                     keyboardType: TextInputType.phone,
//                     validator: (value) => value!.isEmpty ? 'Enter your phone number' : null,
//                   ),
//                   SizedBox(height: 20),
      
//                   // Submit Button
//                   ElevatedButton(
//                     onPressed: updateUserProfile,
//                     child: Text('Update Profile'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:clique/components/auth_button.dart';
import 'package:clique/components/custom_appbar.dart';
import 'package:clique/components/custom_textfield.dart';
import 'package:clique/constants/index.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/utils/utils.dart';
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

  Future<void> pickImage(bool isProfile) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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

  Future<void> updateUserProfile() async {
    if (_formKey.currentState!.validate() && profilePhoto != null && coverPhoto != null) {
      isLoading.value = true; // Set isLoading to true when the API call starts

      try {
        var url = Uri.parse('https://dev.moutfits.com/api/v1/user/update?_method=PUT');
        var request = http.MultipartRequest('POST', url);

        request.headers.addAll({
          'Authorization': 'Bearer ${userController.token.value}',
          'Accept': 'application/json',
        });

        request.fields['name'] = nameController.text;
        // request.fields['email'] = emailController.text;
        request.fields['phone'] = phoneController.text;

        request.files.add(await http.MultipartFile.fromPath('profile_photo', profilePhoto!.path));
        request.files.add(await http.MultipartFile.fromPath('cover_photo', coverPhoto!.path));

        var response = await request.send();

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final Map<String, dynamic> responseData = jsonDecode(responseBody);

          final String userName = responseData["user"]["name"];
          final int userId = responseData["user"]["id"];
          final String role = responseData["user"]["role"];
          final String? profileImage = responseData["user"]["profile_photo_url"];
          final String? coverPhotoUrl = responseData["user"]["cover_photo_url"];
          final String email = responseData["user"]["email"];
          final String phone = responseData["user"]["phone"];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userName', userName);
          await prefs.setString('role', role);
          await prefs.setInt('uid', userId);
          await prefs.setString('profile_photo_url', profileImage ?? '');
          await prefs.setString('cover_photo_url', coverPhotoUrl ?? '');
          await prefs.setString('phone', phone);
          await prefs.setString('email', email);

          await userController.loadUserSession();

          Utils.showCustomSnackBar("Profile Updated", "Profile updated successfully", ContentType.success);
          Get.back();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        isLoading.value = false; // Set isLoading to false when the API call completes
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please complete all fields')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: 'Edit Profile', icon: Icons.arrow_back_ios),
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
                                width: 100, // Same size as cover photo
                                height: 100, // Same size as cover photo
                                decoration: BoxDecoration(
                                  color: Colors.grey[300], // Background color
                                  image: profilePhoto != null
                                      ? DecorationImage(
                                          image: FileImage(profilePhoto!),
                                          fit: BoxFit.cover, // Ensure the image covers the circular area
                                        )
                                      : null,
                                ),
                                child: profilePhoto == null
                                    ? Icon(
                                        Icons.camera_alt,
                                        size: 50, // Icon size
                                        color: Colors.grey[600], // Icon color
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
                                width: 100, // Same size as profile photo
                                height: 100, // Same size as profile photo
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  image: coverPhoto != null
                                      ? DecorationImage(image: FileImage(coverPhoto!), fit: BoxFit.cover)
                                      : null,
                                ),
                                child: coverPhoto == null ? Icon(Icons.camera_alt, size: 50) : null,
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

                  // Name Field
                  CustomTextField(
                    hintText: userController.userName.value,
                    controller: nameController,
                  ),
                  SizedBox(height: 20),

                  // Phone Field
                  CustomTextField(
                    hintText: userController.phone.value,
                    controller: phoneController,
                  ),
                  SizedBox(height: 50),

                  // Update Profile Button
                  AuthButton(
                        buttonText: 'Update Profile',
                        isLoading: isLoading, // Pass the isLoading observable
                        onPressed: updateUserProfile,
                      )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}