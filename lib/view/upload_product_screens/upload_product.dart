// import 'dart:io';
// import 'dart:typed_data';
// import 'package:clique/components/auth_button.dart';
// import 'package:clique/components/custom_textfield.dart';
// import 'package:clique/components/index.dart';
// import 'package:clique/constants/app_colors.dart';
// import 'package:clique/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:get/get.dart';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:video_player/video_player.dart';
// // View Model
// class UploadVideoViewModel extends GetxController {
//   final titleController = TextEditingController();
//   final hashtagsController = TextEditingController();
//   final RxString layout = 'Portrait'.obs; // Change here

//   VideoPlayerController? videoPlayerController;
//   final RxString videoPath = ''.obs;
//   final Rx<Uint8List?> thumbnailImage = Rx<Uint8List?>(null);
//   final Rx<Uint8List?> videoFile = Rx<Uint8List?>(null);
//   final RxString selectedCheckoutOption = 'inline'.obs;
//   final RxBool isVideoSelected = false.obs;

//   @override
//   void onClose() {
//     titleController.dispose();
//     hashtagsController.dispose();
//     videoPlayerController?.dispose();
//     super.onClose();
//   }
// }


// // View
// class UploadVideo extends StatelessWidget {
//   final UploadVideoViewModel viewModel = Get.put(UploadVideoViewModel());

//   UploadVideo({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
    
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _buildAppBar(),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: screenHeight * 0.02),
//               _buildHeader(),
//               SizedBox(height: screenHeight * 0.02),
//               _buildTextFields(screenHeight),
//               SizedBox(height: screenHeight * 0.015),
//               _buildThumbnailSection(screenHeight, screenWidth),
//               SizedBox(height: screenHeight * 0.015),
//               _buildVideoSection(screenHeight, screenWidth),
//               SizedBox(height: screenHeight * 0.02),
//               _buildCheckoutOptions(),
//               SizedBox(height: screenHeight * 0.03),
//               _buildUploadButton(),
//               SizedBox(height: screenHeight * 0.02),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       leading: const BackButton(),
//     );
//   }

//   Widget _buildHeader() {
//     return GradientText(
//       "Create Shoppable Videos",
//       gradient: AppColors.appGradientColors,
//       fontSize: 26
//     );
//   }

// Widget _buildTextFields(double screenHeight) {
//   return Column(
//     children: [
//       CustomTextField(
//         hintText: "Enter Title",
//         controller: viewModel.titleController,
//       ),
//       SizedBox(height: screenHeight * 0.015),
//       CustomTextField(
//         hintText: "Enter Hashtags",
//         controller: viewModel.hashtagsController,
//       ),
//       SizedBox(height: screenHeight * 0.015),
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Select Layout",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//           ),
//           SizedBox(height: 5),
//           Obx(() => DropdownButtonFormField<String>(
//                 value: viewModel.layoutController.text.isNotEmpty
//                     ? viewModel.layoutController.text
//                     : 'Portrait',
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                 ),
//                 items: const [
//                   DropdownMenuItem(
//                     value: 'Portrait',
//                     child: Text('Portrait'),
//                   ),
//                   DropdownMenuItem(
//                     value: 'Horizontal',
//                     child: Text('Horizontal'),
//                   ),
//                 ],
//                 onChanged: (value) {
//                   viewModel.layoutController.text = value!;
//                 },
//               )),
//         ],
//       ),
//     ],
//   );
// }

//   // Widget _buildTextFields(double screenHeight) {
//   //   return Column(
//   //     children: [
//   //       CustomTextField(
//   //         hintText: "Enter Title",
//   //         controller: viewModel.titleController,
//   //       ),
//   //       SizedBox(height: screenHeight * 0.015),
//   //       CustomTextField(
//   //         hintText: "Enter Hashtags",
//   //         controller: viewModel.hashtagsController,
//   //       ),
//   //       SizedBox(height: screenHeight * 0.015),
//   //       CustomTextField(
//   //         hintText: "Portrait",
//   //         controller: viewModel.layoutController,
//   //       ),
//   //     ],
//   //   );
//   // }

//   Widget _buildThumbnailSection(double screenHeight, double screenWidth) {
//     final containerHeight = screenHeight * 0.25;
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Upload Thumbnail",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//         SizedBox(height: screenHeight * 0.01),
//         Obx(() => GestureDetector(
//           onTap: () => viewModel.pickImage(ImageSource.gallery, true),
//           child: viewModel.thumbnailImage.value == null
//               ? _uploadContainer(containerHeight)
//               : ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Image.memory(
//                     viewModel.thumbnailImage.value!,
//                     width: double.infinity,
//                     height: containerHeight,
//                     fit: BoxFit.cover
//                   ),
//                 ),
//         )),
//       ],
//     );
//   }

//   Widget _buildVideoSection(double screenHeight, double screenWidth) {
//     final containerHeight = screenHeight * 0.25;
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Upload Video",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//         SizedBox(height: screenHeight * 0.01),
//         Obx(() => GestureDetector(
//           onTap: () => viewModel.pickVideo(),
//           child: Container(
//             width: double.infinity,
//             height: containerHeight,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: viewModel.isVideoSelected.value && viewModel.videoPlayerController != null
//                 ? ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: VideoPlayer(viewModel.videoPlayerController!),
//                   )
//                 : const Center(child: Icon(Icons.upload, size: 40)),
//           ),
//         )),
//       ],
//     );
//   }

//   Widget _buildCheckoutOptions() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Shopping Flow Redirect",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//         const SizedBox(height: 10),
//         Obx(() => DropdownButtonFormField<String>(
//           value: viewModel.selectedCheckoutOption.value,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             focusColor: Colors.grey,
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.grey),
//             ),
//           ),
//           items: const [
//             DropdownMenuItem(
//               value: 'inline',
//               child: Text('Inline Checkout'),
//             ),
//             DropdownMenuItem(
//               value: 'cart',
//               child: Text('Cart'),
//             ),
//             DropdownMenuItem(
//               value: 'product_page',
//               child: Text('Product Description Page'),
//             ),
//           ],
//           onChanged: (value) {
//             viewModel.selectedCheckoutOption.value = value!;
//           },
//         )),
//       ],
//     );
//   }

//   Widget _buildUploadButton() {
//     return AuthButton(
//       buttonText: 'Upload Video',
//       isLoading: false.obs,
//       onPressed: () => viewModel.uploadVideo(),
//     );
//   }

//   Widget _uploadContainer(double height) {
//     return Container(
//       width: double.infinity,
//       height: height,
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: const Center(child: Icon(Icons.upload, size: 40)),
//     );
//   }
// }




import 'dart:io';
import 'dart:typed_data';
import 'package:clique/components/gradient_text.dart';
import 'package:clique/constants/app_svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clique/components/auth_button.dart';
import 'package:clique/components/custom_textfield.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/utils/utils.dart';

// ViewModel
class UploadVideoViewModel extends GetxController {
  final titleController = TextEditingController();
  final hashtagsController = TextEditingController();
  final RxString layout = 'Portrait'.obs; // Changed from TextEditingController
  final RxList<int> selectedProducts = <int>[].obs; // Add this line

  VideoPlayerController? videoPlayerController;
  final RxString videoPath = ''.obs;
  final Rx<Uint8List?> thumbnailImage = Rx<Uint8List?>(null);
  final Rx<Uint8List?> videoFile = Rx<Uint8List?>(null);
  final RxString selectedCheckoutOption = 'inline'.obs;
  final RxBool isVideoSelected = false.obs;
final RxString selectedProduct = ''.obs;
  @override
  void onClose() {
    titleController.dispose();
    hashtagsController.dispose();
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
      print('Error picking image: $e');
    }
  }

  Future<void> pickVideo() async {
    try {
      final pickedFile =
          await ImagePicker().pickVideo(source: ImageSource.gallery);
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
                   ElevatedButton(
                  style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.black, 
                  ),
        onPressed: () => _openProductPickerBottomSheet(),
        child: Text("Add Products",style: TextStyle(color: Colors.white),),
      ),
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
    return Text(
      "Create Shoppable Videos",
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        foreground: Paint()
          // ..shader = LinearGradient(
          //   colors: AppColors.appGradientColors,
          // ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
              ..shader = AppColors.appGradientColors.createShader(Rect.fromLTWH(0, 0, 200, 70)),
      ),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Layout",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 5),
            Obx(() => DropdownButtonFormField<String>(
                  value: viewModel.layout.value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Portrait',
                      child: Text('Portrait'),
                    ),
                    DropdownMenuItem(
                      value: 'Horizontal',
                      child: Text('Horizontal'),
                    ),
                  ],
                  onChanged: (value) {
                    viewModel.layout.value = value!;
                  },
                )),
            
            // Obx(() => Text("Selected Product: ${viewModel.selectedProduct.value}")), // Display selected product

          ],
        ),
      ],
    );
  }
// void _openProductPickerBottomSheet() {
//   Get.bottomSheet(
//     Container(
//       color: Colors.white,
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Text("Select Products", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           Expanded(
//             child: ListView.builder(
//               itemCount: 10, // Replace with your actual product list length
//               itemBuilder: (context, index) {
//                 return Padding(
//       padding: const EdgeInsets.only(right: 28.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         // crossAxisAlignment: CrossAxisAlignment.sp,
//         children: [
//           Container(
//             height: 50,
//             width:50,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               image: DecorationImage(image: AssetImage(AppSvgIcons.cloth), fit: BoxFit.cover),
//             ),
//           ),
//           SizedBox(width: 12),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Jacket\nBoucle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               GradientText('\$53.23', gradient: AppColors.appGradientColors, fontSize: 14),
//             ],
//           ),
//         ],
//       ),
//     );
//               },
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

void _openProductPickerBottomSheet() {
  Get.bottomSheet(
    Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Select Products",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with your actual product list length
              itemBuilder: (context, index) {
                return Obx(() {
                  // Check if the current product is selected
                  bool isSelected = viewModel.selectedProducts.contains(index);
                  return ListTile(
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(AppSvgIcons.cloth), // Replace with your image
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      'Jacket\nBoucle',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: GradientText(
                      '\$53.23',
                      gradient: AppColors.appGradientColors,
                      fontSize: 14,
                    ),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        // Toggle product selection
                        if (value == true) {
                          viewModel.selectedProducts.add(index); // Add to selected list
                        } else {
                          viewModel.selectedProducts.remove(index); // Remove from selected list
                        }
                      },
                      activeColor: Colors.green, // Green color when selected
                    ),
                    tileColor: isSelected ? Colors.green.withOpacity(0.1) : null, // Background color when selected
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      // Toggle product selection on tap
                      if (isSelected) {
                        viewModel.selectedProducts.remove(index);
                      } else {
                        viewModel.selectedProducts.add(index);
                      }
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
  Widget _buildThumbnailSection(double screenHeight, double screenWidth) {
    final containerHeight = screenHeight * 0.25;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Upload Thumbnail",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
                        fit: BoxFit.cover,
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
        const Text("Upload Video",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
                child: viewModel.isVideoSelected.value &&
                        viewModel.videoPlayerController != null
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
        const Text("Shopping Flow Redirect",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 10),
        Obx(() => DropdownButtonFormField<String>(
              value: viewModel.selectedCheckoutOption.value,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'inline', child: Text('Inline Checkout')),
                DropdownMenuItem(value: 'cart', child: Text('Cart')),
                DropdownMenuItem(value: 'product_page', child: Text('Product Page')),
              ],
              onChanged: (value) => viewModel.selectedCheckoutOption.value = value!,
            )),
      ],
    );
  }

  Widget _buildUploadButton() {
    return AuthButton(buttonText: 'Upload Video', isLoading: false.obs, onPressed: () => viewModel.uploadVideo());
  }

  Widget _uploadContainer(double height) {
    return Container(width: double.infinity, height: height, decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)), child: const Center(child: Icon(Icons.upload, size: 40)));
  }
}
