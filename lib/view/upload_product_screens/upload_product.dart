import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clique/components/auth_button.dart';
import 'package:clique/components/custom_textfield.dart';
import 'package:clique/data/models/product_model.dart';
import 'package:clique/view_model/product_details_controller.dart';
import 'package:clique/view_model/product_view_model.dart';
import 'package:clique/view_model/upload_video_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../constants/index.dart';


class UploadVideo extends StatefulWidget {

  UploadVideo({Key? key}) : super(key: key);

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  final UploadVideoViewModel viewModel = Get.put(UploadVideoViewModel());

  // final ProductController _productViewModel = Get.find<ProductController>();
final ProductViewModel _productViewModel = Get.put(ProductViewModel());
  VideoPlayerController? _videoController;

@override
void dispose() {
      _videoController?.dispose();

  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
    
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02),
            _buildHeader(),
            SizedBox(height: screenHeight * 0.02),
            _buildTextFields(screenHeight),
            SizedBox(height: screenHeight * 0.015),
            _buildThumbnailSection(screenHeight),
            SizedBox(height: screenHeight * 0.015),
            _buildVideoSection(screenHeight),
            SizedBox(height: screenHeight * 0.02),
            // _buildCheckoutOptions(),
            SizedBox(height: screenHeight * 0.02),
            _buildAddProductsButton(),
            SizedBox(height: screenHeight * 0.01),
            _buildUploadButton(),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
    backgroundColor: Colors.white,
        // backgroundColor: Colors.white,
    elevation: 0,
    leading: IconButton(onPressed: ()=> Get.back(),icon: Icon( Icons.arrow_back)) );

  Widget _buildHeader() {
    return Text(
      "Create Shoppable Videos",
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        foreground: Paint()..shader = AppColors.appGradientColors.createShader(Rect.fromLTWH(0, 0, 200, 70)),
      ),
    );
  }

  Widget _buildTextFields(double screenHeight) {
    return Column(
      children: [
        // CustomTextField(hintText: "Enter Title", controller: viewModel.titleController),
        // SizedBox(height: screenHeight * 0.015),
        CustomTextField(hintText: "Enter Hashtags", controller: viewModel.hashtagsController),
        SizedBox(height: screenHeight * 0.015),
        _buildDropdownField("Select Layout", viewModel.layout, ['Portrait', 'Landscape']),
      ],
    );
  }

  Widget _buildDropdownField(String label, RxString selectedValue, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 5),
        Obx(() => DropdownButtonFormField<String>(
              value: selectedValue.value,
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
              onChanged: (value) => selectedValue.value = value!,
            )),
      ],
    );
  }

Widget _buildThumbnailSection(double screenHeight) {
  return _buildThumnailSection(
    "Upload Thumbnail", 
    () => viewModel.pickImage(true),
    viewModel.thumbnailBytes, // Use Uint8List directly
  );
}

Widget _buildVideoSection(double screenHeight) {
  return _buildMediaSection(
    "Upload Video",
    viewModel.pickVideo,
    viewModel.videoFile, // Directly pass Rxn<Uint8List>
  );
}

Widget _buildThumnailSection(String label, VoidCallback onTap, Rxn<Uint8List> file) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      SizedBox(height: 10),
      Obx(() => GestureDetector(
            onTap: onTap,
            child: file.value == null
                ? _uploadContainer()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(file.value!,     width: double.infinity,
      height: 200, fit: BoxFit.cover),
                  ),
          )),
    ],
  );
}

Widget _buildMediaSection(String label, VoidCallback onTap, Rxn<File> file) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      SizedBox(height: 10),
      Obx(() {
        if (file.value == null) {
          return GestureDetector(
            onTap: onTap,
            child: _uploadContainer(),
          );
        } else {
          return _buildVideoPlayer(file.value!);
        }
      }),
    ],
  );
}
Widget _buildVideoPlayer(File videoFile) {
  final controller = VideoPlayerController.file(videoFile);
  _videoController = controller;

  return FutureBuilder(
    future: controller.initialize(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        controller.play();

        final isPortrait = controller.value.aspectRatio < 1;

        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: double.infinity,
            height: isPortrait ? 300 : 200,
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),
        );
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}


  Widget _uploadContainer() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
      child: Center(child: Icon(Icons.upload, size: 40)),
    );
  }

  // Widget _buildCheckoutOptions() {
  void _openProductPickerBottomSheet() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Select Product", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _productViewModel.products.length,
                itemBuilder: (context, index) {
                  final product = _productViewModel.products[index];
                  return Obx(() {
                    bool isSelected = viewModel.selectedProduct.value?.id == product.id;
                    return ListTile(
                      leading: SizedBox(
                        width: 60,
                        height: 60,
                        child: CachedNetworkImage(
                          imageUrl: product.imageUrls.first,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                      title: Text(product.productTitle),
                      trailing: Radio<ProductModel>(
                        value: product,
                        groupValue: viewModel.selectedProduct.value,
                        onChanged: (ProductModel? value) {
                          viewModel.selectedProduct.value = value;
                          Get.back(); // Close the bottom sheet after selection
                        },
                      ),
                      tileColor: isSelected ? Colors.green.withOpacity(0.1) : null,
                      onTap: () {
                        viewModel.selectedProduct.value = product;
                        Get.back(); // Close the bottom sheet after selection
                      },
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddProductsButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
      onPressed: _openProductPickerBottomSheet,
      child: Text("Add Products", style: TextStyle(color: Colors.white)),
    );
  }

  // Widget _buildUploadButton() {
  //   return AuthButton(buttonText: 'Upload Video', isLoading: viewModel.isLoading, onPressed: viewModel.uploadVideo);
  // }
  Widget _buildUploadButton() {
  return AuthButton(
    buttonText: 'Upload Video',
    isLoading: viewModel.isLoading,
    onPressed: () {
      if (viewModel.selectedProduct.value == null) {
        Get.snackbar(
          "Product Required",
          "Please select a product before uploading the video.",
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
        );
      } else {
        viewModel.uploadVideo();
      }
    },
  );
}

}




























