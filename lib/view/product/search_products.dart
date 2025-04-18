
import 'dart:async';

import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/models/product_model.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductSearchScreen extends StatefulWidget {
  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  TextEditingController _searchController = TextEditingController();
  RxBool isLoading = false.obs;
  RxList<dynamic> products = <dynamic>[].obs;
  RxString errorMessage = ''.obs;
Timer? _debounce;

  final userController = Get.find<UserController>();




Future<void> fetchProducts(String searchQuery) async {
  isLoading(true);
  errorMessage('');
  try {
    final response = await http.get(
      Uri.parse(
          'https://cactisocial.com/api-clique/public/api/v1/topdawg/products?page=1&search=$searchQuery'),
      headers: {
        'Authorization': 'Bearer ${userController.token.value}',  // Pass the token in the Authorization header
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> productList = data['products'];
      
      // Map the response into ProductModel objects
      products.value = productList.map((productJson) {
        return ProductModel.fromJson(productJson);
      }).toList();
    } else {
      errorMessage('Failed to load products.');
    }
  } catch (e) {
    errorMessage('Error: $e');
  } finally {
    isLoading(false);
  }
}
@override
void dispose() {
  _debounce?.cancel();
  _searchController.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Search Products'),
        backgroundColor: Colors.grey[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
       TextField(
  controller: _searchController,
  decoration: InputDecoration(
    hintText: 'Search products...',
    prefixIcon: Icon(Icons.search),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey, width: 1), // Set focus border color to grey
    ),
  ),
onChanged: (value) {
  if (_debounce?.isActive ?? false) _debounce!.cancel();
  _debounce = Timer(const Duration(milliseconds: 600), () {
    if (value.isNotEmpty) {
      fetchProducts(value);
    } else {
      products.clear(); // clear the list when search is empty
    }
  });
},

),
         
            SizedBox(height: 16),
            // Display products in a grid
        Expanded(
  child: Obx(
    () {
      if (isLoading.value) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 10, // Show shimmer effect for 10 items
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          },
        );
      } else if (products.isEmpty) {
        return Center(child: Text('No products found.'));
      } else {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            ProductModel product = products[index];
            return GestureDetector(
              onTap: (){
                  Get.toNamed(
    RouteName.productDetailsScreen,
    arguments: {
      'uid': product.id.toString(),
      'backgroundImage': product.imageUrls,
      'productName': product.productTitle,
      'productDescription': product.productDesc,
      'price': product.cost,
      'oldPrice': product.msrp,
      'discount': 0.0,
      'unit': product.unit,
      'categories':product.categories,
      'size':product.productWeight,
    },
  );
              },
              child: Card(
              
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: Stack(
                        children: [
              
                          CachedNetworkImage(
                            imageUrl: product.thumbnailUrl,
                            fit: BoxFit.cover,
                            height: 150,
                            width: double.infinity,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error, color: Colors.red),
                          ),
                                        Container(
  width: double.infinity,
  height: MediaQuery.of(context).size.height * 0.187, // 20% of screen height
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        Colors.black.withOpacity(0.6),
        Colors.transparent,
      ],
    ),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      
      bottomRight: Radius.circular(16),
      bottomLeft: Radius.circular(16),
    ),
  ),
),

                              Positioned(
                                    bottom: 8,
                left: 0,
                right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    //  '${product.productTitle.substring(0, 15)}...'  // Show first 10 characters and ellipsis
                                      // If title is less than or equal to 10 characters, show the whole title
                                     product.productTitle,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,  // Ensure that text is truncated with an ellipsis
                                    ),
                                  ),
                                ),
                              )
              
                        ],
                      ),
                    ),
              
                  ],
                ),
              ),
            );
          },
        );
      }
    },
  ),
)

          ],
        ),
      ),
    );
  }
}
