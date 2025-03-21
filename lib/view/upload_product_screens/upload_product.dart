import 'dart:typed_data';

import 'package:clique/components/auth_button.dart';
import 'package:clique/components/custom_textfield.dart';
import 'package:clique/view_model/upload_video_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../constants/index.dart';


class UploadVideo extends StatelessWidget {
  final UploadVideoViewModel viewModel = Get.put(UploadVideoViewModel());

  UploadVideo({Key? key}) : super(key: key);

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
            _buildCheckoutOptions(),
            SizedBox(height: screenHeight * 0.03),
            _buildAddProductsButton(),
            SizedBox(height: screenHeight * 0.03),
            _buildUploadButton(),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(leading: const BackButton());

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
        CustomTextField(hintText: "Enter Title", controller: viewModel.titleController),
        SizedBox(height: screenHeight * 0.015),
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
  return _buildMediaSection(
    "Upload Thumbnail", 
    () => viewModel.pickImage(true),
    viewModel.thumbnailBytes, // Use Uint8List directly
  );
}

Widget _buildVideoSection(double screenHeight) {
  return _buildMediaSection(
    "Upload Video", 
    viewModel.pickVideo, 
    viewModel.videoFile.map((file) => file?.readAsBytesSync()).obs, // Convert File to Uint8List
  );
}
Widget _buildMediaSection(String label, VoidCallback onTap, Rxn<Uint8List> file) {
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
                    child: Image.memory(file.value!, width: double.infinity, fit: BoxFit.cover),
                  ),
          )),
    ],
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

  Widget _buildCheckoutOptions() {
    return _buildDropdownField("Shopping Flow Redirect", viewModel.selectedCheckoutOption, ['Inline Checkout', 'Cart', 'Product Page']);
  }

  Widget _buildAddProductsButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
      onPressed: _openProductPickerBottomSheet,
      child: Text("Add Products", style: TextStyle(color: Colors.white)),
    );
  }

  void _openProductPickerBottomSheet() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Select Products", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Obx(() {
                    bool isSelected = viewModel.selectedProducts.contains(index);
                    return ListTile(
                      leading: Icon(Icons.shopping_bag),
                      title: Text('Product $index'),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (value) {
                          if (value == true) {
                            viewModel.selectedProducts.add(index);
                          } else {
                            viewModel.selectedProducts.remove(index);
                          }
                        },
                      ),
                      tileColor: isSelected ? Colors.green.withOpacity(0.1) : null,
                      onTap: () => isSelected ? viewModel.selectedProducts.remove(index) : viewModel.selectedProducts.add(index),
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

  Widget _buildUploadButton() {
    return AuthButton(buttonText: 'Upload Video', isLoading: viewModel.isLoading, onPressed: viewModel.uploadVideo);
  }
}
