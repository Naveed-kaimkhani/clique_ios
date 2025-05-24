import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:clique/data/models/product_model.dart';
import 'package:clique/models/upload_video_response.dart';
import 'package:clique/utils/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class UploadVideoService {
  static const String baseUrl =
      "https://cactisocial.com/api-clique/public/api/v1/popstream/create";
  Future<UploadVideoResponse> uploadVideo({
    required File thumbnail,
    required File video,
    required String userId,
    required String name,
    required String showType,
    required String lambdaToken,
    required List<ProductModel> product,
    required String createdBy,
    required String authToken,
  }) async {
    try {
      final productIds = product
          .map((e) => e.productTitle
                  .toString()
                  .toLowerCase()
                  .replaceAll(RegExp(r'\s+'), '') // Remove whitespace
              )
          .toList();

      // log("product ids");
      // log(productIds.toString());
      // log(jsonEncode(productIds));
      // final ids =
      //     jsonEncode(productIds); // '["comfymatpetbed","anchorsawaypetbed"]'
      // final ids3 = '["$ids"]'; // Static version
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      request.headers['Authorization'] = 'Bearer $authToken';
      request.headers['Content-Type'] = 'multipart/form-data';

      request.files.add(await http.MultipartFile.fromPath(
        'thumbnail_file', thumbnail.path,
        contentType: MediaType('image', 'jpeg'), // Adjust type
      ));

      request.files.add(await http.MultipartFile.fromPath(
        'video_file', video.path,
        contentType: MediaType('video', 'mp4'), // Adjust type
      ));
      request.fields['user_id'] = userId;
      request.fields['show_type'] = showType.toLowerCase(); // Ensure lowercase
      request.fields['lambda_token'] = lambdaToken;
      request.fields['created_by'] = createdBy;
// request.fields['product_ids'] = productIds;
      addProductIdsToMultipartRequest(request, productIds);

// request.fields['product_ids'] = productIds;
// for (var id in productIds) {
//   request.fields['product_ids'] = id;
// }
      // request.fields['name'] = product.productTitle;
      // request.fields['product_price'] = product.cost.toString();
      // request.fields['product_image'] = product.imageUrls.first;
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      if (response.statusCode == 202) {
        var decoded = jsonDecode(responseBody);
        Utils.showCustomSnackBar("Success",
            "PopStream request is pending approval", ContentType.success);
        Get.back();
        return UploadVideoResponse.fromJson(decoded);
      } else {
        return UploadVideoResponse(success: false, message: responseBody);
      }
    } catch (e) {
      return UploadVideoResponse(success: false, message: "Error: $e");
    }
  }

  void addProductIdsToMultipartRequest(
      http.MultipartRequest request, List<String> productIds) {
    if (productIds.isNotEmpty) {
      for (int index = 0; index < productIds.length; index++) {
        final productId = productIds[index];
        // Use $index to interpolate the value, not the literal string "index"
        request.fields["product_ids[$index]"] = productId;
      }
    }
  }
}
