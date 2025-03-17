import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<void> updateUserProfile({
  required String name,
  required String email,
  required String phone,
  required File profilePhoto,
  required File coverPhoto,
  required String token, // Bearer token
}) async {
  var url = Uri.parse('https://dev.moutfits.com/api/v1/user/update?_method=PUT');

  var request = http.MultipartRequest('POST', url);
  request.headers.addAll({
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  });

  // Add form fields
  request.fields['name'] = name;
  request.fields['email'] = email;
  request.fields['phone'] = phone;

  // Attach profile and cover photos
  request.files.add(await http.MultipartFile.fromPath('profile_photo', profilePhoto.path));
  request.files.add(await http.MultipartFile.fromPath('cover_photo', coverPhoto.path));

  // Send request
  var response = await request.send();

  // Handle response
  if (response.statusCode == 200) {
    print('Profile updated successfully');
  } else {
    print('Failed to update profile. Status: ${response.statusCode}');
  }
}

// Function to pick an image
Future<File?> pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  return pickedFile != null ? File(pickedFile.path) : null;
}

// Usage example
void main() async {
  String token = "YOUR_BEARER_TOKEN"; // Replace with your token
  File? profilePhoto = await pickImage();
  File? coverPhoto = await pickImage();

  if (profilePhoto != null && coverPhoto != null) {
    await updateUserProfile(
      name: "Updated Name",
      email: "test@example.com",
      phone: "03333333336",
      profilePhoto: profilePhoto,
      coverPhoto: coverPhoto,
      token: token,
    );
  } else {
    print("Image selection canceled");
  }
}
