import 'dart:typed_data';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';
class Utils {
  static String mapErrorMessage(String error) {
  if (error.contains("The email has already been taken")) {
    return "This email is already registered. Please use another email or log in.";
  } if (error.contains("The provided credentials are incorrect")) {
    return "Invalid email or password. Please try again";
  } else if (error.contains("network")) {
    return "No internet connection. Please check your connection.";
  } else if (error.contains("invalid credentials")) {
    return "Invalid email or password. Please try again.";
  } if (error.contains("The phone has already been taken")) {
    return "This phone is already registered. Please use another phone or log in.";
  }else {
    return error;
    // return "Something went wrong. Please try again later.";
  }
}

// static Future<void> saveJoinedGroup(String guid) async {
//   final prefs = await SharedPreferences.getInstance();
//   List<String> joinedGroups = prefs.getStringList('joined_groups') ?? [];
//   if (!joinedGroups.contains(guid)) {
//     joinedGroups.add(guid);
//     await prefs.setStringList('joined_groups', joinedGroups);
//   }
// }
static Future<List<String>> getJoinedGroups() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('joined_groups') ?? [];
}

 static void showCustomSnackBar(String title, String message, ContentType contentType) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      dismissDirection: DismissDirection.up,
      animation: CurvedAnimation(
        parent: AnimationController(
          vsync: Navigator.of(Get.context!),
          duration: const Duration(milliseconds: 500),
        )..forward(),
        curve: Curves.easeInOut,
      ),
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }
  static Future<Uint8List?> pickImage() async {
    //    ImagePicker picker=ImagePicker();
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      XFile compressedImage = await compressImage(file);
      return compressedImage.readAsBytes();
    }
    return null;
  }

 static String formatTimeOfDay(TimeOfDay time, context) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return MaterialLocalizations.of(context).formatTimeOfDay(time);
}

  static Future<XFile> compressImage(XFile image) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp.jpg';

    // converting original image to compress it
    final result = await FlutterImageCompress.compressAndGetFile(
      image.path,
      targetPath,
      minHeight: 1080, //you can play with this to reduce siz
      minWidth: 1080,
      quality: 90, // keep this high to get the original quality of image
    );
    return result!;
  }

}