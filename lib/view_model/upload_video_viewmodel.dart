import 'dart:typed_data';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/models/product_model.dart';
import 'package:clique/data/repositories/upload_video_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../utils/utils.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class UploadVideoViewModel extends GetxController {
  final UploadVideoService _uploadService = UploadVideoService();
  final userController = Get.find<UserController>();
  final titleController = TextEditingController();
  final hashtagsController = TextEditingController();
  final RxString layout = 'Portrait'.obs;  
  final Rx<ProductModel?> selectedProduct = Rx<ProductModel?>(null); // Changed to single product

  var thumbnailBytes = Rxn<Uint8List>(); // Store Uint8List for UI

   var selectedCheckoutOption = RxString('Inline Checkout'); // Default value

 var thumbnailFile = Rxn<File>(); // Store as File
  var videoFile = Rxn<File>();
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

  Future<void> uploadVideo() async {
    if (thumbnailFile.value == null || videoFile.value == null) {
      Utils.showCustomSnackBar("Warning", "Please select a thumbnail and video", ContentType.warning);
      return;
    }
     if (titleController.text.isEmpty) {
      Utils.showCustomSnackBar("Warning", "Please select a thumbnail and video", ContentType.warning);
      return;
    }

    isLoading.value = true;
  if (selectedProduct.value==null) {
    Utils.showCustomSnackBar("Warning", "Please Select a product", ContentType.warning);
  } else {
      var response = await _uploadService.uploadVideo(
      thumbnail: thumbnailFile.value!,
      video: videoFile.value!,
      userId:userController.uid.toString(),  // Replace with actual user ID
      name: titleController.text,
      product:   selectedProduct.value!,   
      showType: layout.value,
      // product: ProductModel(id: 111, productWeight: "", productTitle: "productTitle", productDesc: "productDesc", brandName: "brandName", unit: "s", cost: 12, msrp: 12, imageUrls: List<S>, thumbnailUrl: "thumbnailUrl", categories: "categories", variantGroupId: "variantGroupId"),  // Replace with actual product
      lambdaToken: userController.revoLamdaToken.value,  // Replace with actual token
      createdBy: userController.userEmail.value,  // Replace with actual email
      authToken: userController.token.value,  // Replace with actual token
    );
  }
    isLoading.value = false;
  }

  @override
  void onClose() {
    titleController.dispose();
    hashtagsController.dispose();
    super.onClose();
  }
}
