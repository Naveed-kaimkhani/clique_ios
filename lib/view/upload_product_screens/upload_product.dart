import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:clique/components/auth_button.dart';
import 'package:clique/components/custom_textfield.dart';
import 'package:clique/components/index.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:video_player/video_player.dart';
// View Model
class UploadVideoViewModel extends GetxController {
  final titleController = TextEditingController();
  final hashtagsController = TextEditingController();
  final layoutController = TextEditingController();
  VideoPlayerController? videoPlayerController;
  final RxString videoPath = ''.obs;

  final Rx<Uint8List?> thumbnailImage = Rx<Uint8List?>(null);
  final Rx<Uint8List?> videoFile = Rx<Uint8List?>(null);
  final RxString selectedCheckoutOption = 'inline'.obs;
  final RxBool isVideoSelected = false.obs;

  @override
  void onClose() {
    titleController.dispose();
    hashtagsController.dispose();
    layoutController.dispose();
    
    videoPlayerController?.dispose();
    super.onClose();
  }

  Future<void> pickImage(ImageSource source, bool isThumbnail) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        if (isThumbnail) {
          thumbnailImage.value = imageBytes;
        } else {
          videoFile.value = imageBytes;
        }
      }
    } catch (e) {
      // Handle error appropriately
      print('Error picking image: $e');
    }
  }

  Future<void> pickVideo() async {
    try {
      final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        videoPath.value = pickedFile.path;
        videoPlayerController?.dispose();
        videoPlayerController = VideoPlayerController.file(File(videoPath.value))
          ..initialize().then((_) {
            isVideoSelected.value = true;
            videoPlayerController?.play();
            update();
          });
      }
    } catch (e) {
      log(e.toString());
      Utils.showCustomSnackBar("Error", "$e", ContentType.failure);
    }
  }

  Future<void> uploadVideo() async {
    // Implement video upload logic
  }
}

// View
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              _buildHeader(),
              SizedBox(height: screenHeight * 0.02),
              _buildTextFields(screenHeight),
              SizedBox(height: screenHeight * 0.015),
              _buildThumbnailSection(screenHeight, screenWidth),
              SizedBox(height: screenHeight * 0.015),
              _buildVideoSection(screenHeight, screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildCheckoutOptions(),
              SizedBox(height: screenHeight * 0.03),
              _buildUploadButton(),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: const BackButton(),
    );
  }

  Widget _buildHeader() {
    return GradientText(
      "Create Shoppable Videos",
      gradient: AppColors.appGradientColors,
      fontSize: 26
    );
  }

  Widget _buildTextFields(double screenHeight) {
    return Column(
      children: [
        CustomTextField(
          hintText: "Enter Title",
          controller: viewModel.titleController,
        ),
        SizedBox(height: screenHeight * 0.015),
        CustomTextField(
          hintText: "Enter Hashtags",
          controller: viewModel.hashtagsController,
        ),
        SizedBox(height: screenHeight * 0.015),
        CustomTextField(
          hintText: "Portrait",
          controller: viewModel.layoutController,
        ),
      ],
    );
  }

  Widget _buildThumbnailSection(double screenHeight, double screenWidth) {
    final containerHeight = screenHeight * 0.25;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upload Thumbnail",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: screenHeight * 0.01),
        Obx(() => GestureDetector(
          onTap: () => viewModel.pickImage(ImageSource.gallery, true),
          child: viewModel.thumbnailImage.value == null
              ? _uploadContainer(containerHeight)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    viewModel.thumbnailImage.value!,
                    width: double.infinity,
                    height: containerHeight,
                    fit: BoxFit.cover
                  ),
                ),
        )),
      ],
    );
  }

  Widget _buildVideoSection(double screenHeight, double screenWidth) {
    final containerHeight = screenHeight * 0.25;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upload Video",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: screenHeight * 0.01),
        Obx(() => GestureDetector(
          onTap: () => viewModel.pickVideo(),
          child: Container(
            width: double.infinity,
            height: containerHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: viewModel.isVideoSelected.value && viewModel.videoPlayerController != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: VideoPlayer(viewModel.videoPlayerController!),
                  )
                : const Center(child: Icon(Icons.upload, size: 40)),
          ),
        )),
      ],
    );
  }

  Widget _buildCheckoutOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Shopping Flow Redirect",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Obx(() => DropdownButtonFormField<String>(
          value: viewModel.selectedCheckoutOption.value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            focusColor: Colors.grey,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
          items: const [
            DropdownMenuItem(
              value: 'inline',
              child: Text('Inline Checkout'),
            ),
            DropdownMenuItem(
              value: 'cart',
              child: Text('Cart'),
            ),
            DropdownMenuItem(
              value: 'product_page',
              child: Text('Product Description Page'),
            ),
          ],
          onChanged: (value) {
            viewModel.selectedCheckoutOption.value = value!;
          },
        )),
      ],
    );
  }

  Widget _buildUploadButton() {
    return AuthButton(
      buttonText: 'Upload Video',
      isLoading: false.obs,
      onPressed: () => viewModel.uploadVideo(),
    );
  }

  Widget _uploadContainer(double height) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(child: Icon(Icons.upload, size: 40)),
    );
  }
}
