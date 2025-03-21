import 'dart:typed_data';
import 'package:clique/data/repositories/upload_video_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../utils/utils.dart';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
class UploadVideoViewModel extends GetxController {
  final UploadVideoService _uploadService = UploadVideoService();

  final titleController = TextEditingController();
  final hashtagsController = TextEditingController();
  final RxString layout = 'Portrait'.obs;
  final RxList<int> selectedProducts = <int>[].obs;
  var thumbnailBytes = Rxn<Uint8List>(); // Store Uint8List for UI

   var selectedCheckoutOption = RxString('Inline Checkout'); // Default value

 var thumbnailFile = Rxn<File>(); // Store as File
  var videoFile = Rxn<File>();
  // var videoFile = Rxn<File>();  // Store the selected file
  var videoBytes = Rxn<Uint8List>(); // Store Uint8List for UI preview

  final RxBool isLoading = false.obs;

  Future<void> pickImage(bool isThumbnail) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      
      if (isThumbnail) {
        thumbnailFile.value = file;
        thumbnailBytes.value = await file.readAsBytes();  // Convert File to Uint8List
      }
    }
  }
Future<void> pickVideo() async {
  final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
  if (pickedFile != null) {
    File file = File(pickedFile.path);
    videoFile.value = file;
    videoBytes.value = await file.readAsBytes(); // Convert File to Uint8List
  }
}

//  Future<void> pickVideo() async {
//     final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    
//     if (pickedFile != null) {
//       File file = File(pickedFile.path);
      
//       videoFile.value = file;
//       videoBytes.value = await file.readAsBytes();  // Convert File to Uint8List
//     }
//   }
  Future<void> uploadVideo() async {
    if (thumbnailFile.value == null || videoFile.value == null) {
      Utils.showCustomSnackBar("Error", "Please select a thumbnail and video", ContentType.warning);
      return;
    }

    isLoading.value = true;
    var response = await _uploadService.uploadVideo(
      thumbnail: thumbnailFile.value!,
      video: videoFile.value!,
      userId: "432432423234",  // Replace with actual user ID
      name: titleController.text,
      showType: layout.value,
      lambdaToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6Im5hdmVlZGthaW1raGFtaUBnbWFpbC5jb20iLCJvcmduYW1lIjoiYWRtaW5fdXNlciIsImNyZWF0ZWRfb24iOjAsImlzcmVnaXN0ZXJlZCI6dHJ1ZX0.iihJJO7nUSAKqH6f4gYEfV6qLTQGThuXQG-bQJsfEuM",  // Replace with actual token
      createdBy: "naveed@gmail.com",  // Replace with actual email
      authToken: "257|VR9svQCn7tuN1Ilq7lghllUiBSUq8nsvxvlqYs0y6ed0e9a6",  // Replace with actual token
    );

    isLoading.value = false;

    // if (response.success) {
    //   Utils.showCustomSnackBar("Success", response.message, ContentType.success);
    // } else {
    //   Utils.showCustomSnackBar("Error", response.message, ContentType.failure);
    // }
  }

  @override
  void onClose() {
    titleController.dispose();
    hashtagsController.dispose();
    super.onClose();
  }
}
