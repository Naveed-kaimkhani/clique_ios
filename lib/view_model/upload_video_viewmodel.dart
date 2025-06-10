import 'dart:typed_data';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/models/pop_stream_model.dart';
import 'package:clique/data/models/popstream_product.dart';
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

  final RxList<PopstreamProduct> selectedProducts = <PopstreamProduct>[].obs;
  // final RxList<ProductModel> selectedProducts = <ProductModel>[].obs;
  var thumbnailBytes = Rxn<Uint8List>(); // Store Uint8List for UI

  var selectedCheckoutOption = RxString('Inline Checkout'); // Default value

  var thumbnailFile = Rxn<File>(); // Store as File
  var videoFile = Rxn<File>();
  var videoBytes = Rxn<Uint8List>(); // Store Uint8List for UI preview
  final RxDouble uploadProgress = 0.0.obs;

  final RxBool isLoading = false.obs;

  // RxList<PopstreamModel> products = <PopstreamModel>[].obs; // 👈 Add this


  RxList<PopstreamProduct> products = <PopstreamProduct>[].obs; // 👈 Add this


  // RxList<ProductModel> selectedProducts = <ProductModel>[].obs;

  Future<void> pickImage(bool isThumbnail) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);

      if (isThumbnail) {
        thumbnailFile.value = file;
        thumbnailBytes.value =
            await file.readAsBytes(); // Convert File to Uint8List
      }
    }
  }

  Future<void> pickVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      int sizeInBytes = await file.length();
      double sizeInMB = sizeInBytes / (1024 * 1024);

      if (sizeInMB > 500) {
        Utils.showCustomSnackBar(
          "Warning",
          "Selected video exceeds the 500MB limit",
          ContentType.warning,
        );
        return;
      }

      videoFile.value = file;
      videoBytes.value = await file.readAsBytes(); // Convert File to Uint8List
    }
  }

  Future<void> uploadVideo() async {
   
    if (thumbnailFile.value == null || videoFile.value == null) {
      Utils.showCustomSnackBar("Warning", "Please select a thumbnail and video",
          ContentType.warning);
      return;
    }
    if (hashtagsController.text.isEmpty) {
      Utils.showCustomSnackBar(
          "Warning", "Please add hashtags", ContentType.warning);
      return;
    }
    isLoading.value = true;
    if (selectedProducts.isEmpty) {
      Utils.showCustomSnackBar(
          "Warning", "Please Select a products", ContentType.warning);
    } else {
      var response = await _uploadService.uploadVideo(
        thumbnail: thumbnailFile.value!,
        video: videoFile.value!,
        userId: userController.uid.toString(), // Replace with actual user ID
        name: titleController.text,
        product: selectedProducts,
        showType: layout.value,
        // product: ProductModel(id: 111, productWeight: "", productTitle: "productTitle", productDesc: "productDesc", brandName: "brandName", unit: "s", cost: 12, msrp: 12, imageUrls: List<S>, thumbnailUrl: "thumbnailUrl", categories: "categories", variantGroupId: "variantGroupId"),  // Replace with actual product
        lambdaToken:
            userController.revoLamdaToken.value, // Replace with actual token
        createdBy: userController.userEmail.value, // Replace with actual email
        authToken: userController.token.value, // Replace with actual token
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
