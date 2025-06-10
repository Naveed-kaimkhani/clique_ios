import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:clique/data/models/popstream_product.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clique/components/auth_button.dart';
import 'package:clique/components/custom_textfield.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/models/product_model.dart';
import 'package:clique/view_model/upload_video_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import '../../constants/index.dart';

class UploadVideo extends StatefulWidget {
  UploadVideo({Key? key}) : super(key: key);

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  final UploadVideoViewModel viewModel = Get.put(UploadVideoViewModel());

  // final ProductViewModel _productViewModel = Get.put(ProductViewModel());
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
      body: Stack(
        children: [
          SingleChildScrollView(
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

                _buildSelectedProductsList(), // <-- Add this line
                SizedBox(height: screenHeight * 0.02),
                SizedBox(height: screenHeight * 0.02),
                _buildAddProductsButton(),

                SizedBox(height: screenHeight * 0.01),
                SizedBox(height: screenHeight * 0.02),
                _buildUploadButton(),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
          Obx(() {
            if (viewModel.isLoading.value) {
              return AbsorbPointer(
                // 👈 Prevents user interaction
                absorbing: true,
                child: Container(
                  color: Colors.black
                      .withOpacity(0.4), // 👈 Semi-transparent overlay
                  alignment: Alignment.center,
                  child: SpinKitFadingCircle(
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
      backgroundColor: Colors.white,
      // backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
          onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_ios)));

  Widget _buildHeader() {
    return Text(
      "Create Shoppable Videos",
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        foreground: Paint()
          ..shader = AppColors.appGradientColors
              .createShader(Rect.fromLTWH(0, 0, 200, 70)),
      ),
    );
  }

  Widget _buildTextFields(double screenHeight) {
    return CustomTextField(
        hintText: "Add Caption", controller: viewModel.hashtagsController);
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

  Widget _buildThumnailSection(
      String label, VoidCallback onTap, Rxn<Uint8List> file) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 10),
        Obx(() => GestureDetector(
              onTap: onTap,
              child: file.value == null
                  ? _uploadContainer()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(file.value!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover),
                    ),
            )),
      ],
    );
  }

  Widget _buildMediaSection(String label, VoidCallback onTap, Rxn<File> file) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 10),
        Obx(() {
          return GestureDetector(
            onTap: onTap, // 👈 Allow selecting new video on tap
            child: file.value == null
                ? _uploadContainer()
                : _buildVideoPlayer(file.value!),
          );
        }),
      ],
    );
  }

  Widget _buildVideoPlayer(File videoFile) {
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(videoFile);
    final controller = _videoController!;

    return FutureBuilder(
      future: controller.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          controller.play();
          final aspectRatio = controller.value.aspectRatio;

          return LayoutBuilder(
            builder: (context, constraints) {
              double maxHeight = 300;
              double calculatedWidth = maxHeight * aspectRatio;

              // Cap the width if it overflows the screen
              double finalWidth = calculatedWidth > constraints.maxWidth
                  ? constraints.maxWidth
                  : calculatedWidth;

              double finalHeight = finalWidth / aspectRatio;

              return Center(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(12), // 🎯 Rounded corners here
                  child: SizedBox(
                    width: finalWidth,
                    height: finalHeight,
                    child: VideoPlayer(controller),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
      },
    );
  }

  Widget _uploadContainer() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: Center(child: Icon(Icons.upload, size: 40)),
    );
  }

  Widget shimmerBox(double width, double height) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }

  void _openProductPickerBottomSheet() {
    final userController = Get.find<UserController>();
    final viewModel = Get.find<UploadVideoViewModel>(); // <-- Your view model
    final RxString searchQuery = ''.obs;
    // final RxList<ProductModel> searchResults = <ProductModel>[].obs;

    final RxList<PopstreamProduct> searchResults = <PopstreamProduct>[].obs;

    final RxBool isLoading = false.obs;
    Timer? _debounce;

    // Future<void> fetchProducts(String query) async {
    //   isLoading(true);
    //   try {
    //     final response = await http.get(
    //       Uri.parse(
    //         'https://cactisocial.com/api-clique/public/api/v1/topdawg/products?search=$query',
    //       ),
    //       headers: {
    //         'Authorization': 'Bearer ${userController.token.value}',
    //       },
    //     );
    //     if (response.statusCode == 200) {
    //       final data = jsonDecode(response.body);
    //       final List<dynamic> productList = data['products'];
    //       searchResults.value =
    //           productList.map((json) => ProductModel.fromJson(json)).toList();
    //     } else {
    //       searchResults.clear();
    //     }
    //   } catch (e) {
    //     searchResults.clear();
    //   } finally {
    //     isLoading(false);
    //   }
    // }
    Future<void> fetchProducts(String query) async {
      isLoading(true);
      try {
        final response = await http.post(
          Uri.parse(
              'https://clique.revovideo.io/api/product/get-products?language=en'),
          headers: {
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJuZXh0Z2VuZXJhdGlvbnNkZXZlbG9wZXJAZ21haWwuY29tIiwianRpIjoiMTM2NTYwYzgtNTZiZS00MmU3LWIxMjgtOWNlNGQ4NmM5ZjgwIiwiZXhwIjoxNzQ5NTg4NDk0LCJpc3MiOiJyZXZvLmNsaXF1ZSIsImF1ZCI6InJldm8uY2xpcXVlIn0.GtBOzrw_QcFT5N3oNEhF36mPjIyeOyDNy_h7zIwWlGc',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "limit": 20,
            "category_id": "",
            "lastevalkey": "",
            "store_id": "74803392581300891193703650301_1746030346883",
            "consultant_id": "",
            "search_text": query
          }),
        );
        // log(response.body);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          // Adjust this depending on your API's response structure:
          final List<dynamic> productList = data['products'];
          log(productList.toString());
          searchResults.value = productList
              .map((json) => PopstreamProduct.fromJson(json))
              .toList();
          // log(searchResults.value.toString());
        } else {
          searchResults.clear();
        }
      } catch (e) {
        searchResults.clear();
      } finally {
        isLoading(false);
      }
    }

    Get.bottomSheet(
      Container(
        height: 500,
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Select Products",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Search field
            TextField(
              onChanged: (value) {
                searchQuery.value = value;

                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(Duration(milliseconds: 600), () {
                  if (value.isNotEmpty) {
                    fetchProducts(value);
                  } else {
                    searchResults.clear();
                  }
                });
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 10),

            Obx(() => Text(
                  "Selected: ${viewModel.selectedProducts.length}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                )),
            SizedBox(height: 10),

            // Product list

            Expanded(
              child: Obx(() {
                List<PopstreamProduct> productsToShow =
                    searchQuery.value.isEmpty
                        ? viewModel.products
                        : searchResults;

                if (isLoading.value && searchQuery.value.isNotEmpty) {
                  return ListView.builder(
                    itemCount: 6,
                    itemBuilder: (_, __) => ListTile(
                      leading: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 60,
                          height: 60,
                          color: Colors.white,
                        ),
                      ),
                      title: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 12,
                          width: 100,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                } else if (productsToShow.isEmpty) {
                  return Center(child: Text("No products found."));
                } else {
                  return ListView.builder(
                    itemCount: productsToShow.length,
                    itemBuilder: (context, index) {
                      PopstreamProduct product = productsToShow[index];

                      return Obx(() {
                        final isSelected = viewModel.selectedProducts
                            .any((p) => p.id == product.id);

                        return ListTile(
                          leading: SizedBox(
                            width: 60,
                            height: 60,
                            child: CachedNetworkImage(
                              imageUrl: product.imageUrls.first,
                              fit: BoxFit.cover,
                              placeholder: (_, __) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (_, __, ___) => Icon(Icons.error),
                            ),
                          ),
                          title: Text(product.productTitle),
                          trailing: Checkbox(
                            value: isSelected,
                            onChanged: (_) {
                              if (isSelected) {
                                viewModel.selectedProducts
                                    .removeWhere((p) => p.id == product.id);
                                Fluttertoast.showToast(
                                  msg:
                                      "${product.productTitle} removed from selection.",
                                  backgroundColor:
                                      Colors.redAccent.withOpacity(0.8),
                                );
                              } else {
                                viewModel.selectedProducts.add(product);
                                Fluttertoast.showToast(
                                  msg:
                                      "${product.productTitle} added to selection.",
                                  backgroundColor:
                                      Colors.green.withOpacity(0.8),
                                );
                              }
                            },
                          ),
                          onTap: () {
                            if (isSelected) {
                              viewModel.selectedProducts
                                  .removeWhere((p) => p.id == product.id);
                              Fluttertoast.showToast(
                                msg:
                                    "${product.productTitle} removed from selection.",
                                backgroundColor:
                                    Colors.redAccent.withOpacity(0.8),
                              );
                            } else {
                              viewModel.selectedProducts.add(product);
                              // Fluttertoast.showToast(
                              //   msg:
                              //       "${product.productTitle} added to selection.",
                              //   backgroundColor: Colors.green.withOpacity(0.8),
                              // );
                              Fluttertoast.showToast(
                                msg: "${product} added to selection.",
                                backgroundColor: Colors.green.withOpacity(0.8),
                              );
                            }
                          },
                        );
                      });
                    },
                  );
                }
              }),
            ),

            // Optional: Done button to close the sheet
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Done"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildAddProductsButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
      onPressed: () {
        _openProductPickerBottomSheet(); // ✅ Call method
      },
      child: Text("Add Product", style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildUploadButton() {
    return AuthButton(
      buttonText: 'Upload Video',
      isLoading: viewModel.isLoading,
      onPressed: () {
        if (viewModel.selectedProducts.isEmpty) {
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

  Widget _buildSelectedProductsList() {
    return Obx(() {
      if (viewModel.selectedProducts.isEmpty) {
        return SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            "Selected Products",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.selectedProducts.length,
              itemBuilder: (context, index) {
                final product = viewModel.selectedProducts[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Stack(
                    children: [
                      Container(
                        width: 80,
                        child: Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: product.imageUrls.first,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (_, __, ___) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              product.productTitle.length > 10
                                  ? '${product.productTitle.substring(0, 10)}...'
                                  : product.productTitle,
                              style: TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            viewModel.selectedProducts.removeAt(index);
                            Fluttertoast.showToast(
                              msg: "${product.productTitle} removed",
                              backgroundColor:
                                  Colors.redAccent.withOpacity(0.8),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
