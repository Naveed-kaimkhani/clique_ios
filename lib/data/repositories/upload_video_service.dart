import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:clique/models/upload_video_response.dart';
import 'package:clique/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
class UploadVideoService {
  static const String baseUrl = "https://dev.moutfits.com/api/v1/popstream/create";

 

  Future<UploadVideoResponse> uploadVideo({
  required File thumbnail,
  required File video,
  required String userId,
  required String name,
  required String showType,
  required String lambdaToken,
  required String createdBy,
  required String authToken,
}) async {
  try {
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
    request.fields['name'] = name;
    request.fields['show_type'] = showType.toLowerCase(); // Ensure lowercase
    request.fields['lambda_token'] = lambdaToken;
    request.fields['created_by'] = createdBy;

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    log("Response Status Code: ${response.statusCode}");
    log("Response Body: $responseBody");

    if (response.statusCode == 202) {
      var decoded = jsonDecode(responseBody);
      
 Utils.showCustomSnackBar("Success", "PopStream request is pending approval", ContentType.success);
 Get.back();
      return UploadVideoResponse.fromJson(decoded);
    } else {
      return UploadVideoResponse(success: false, message: responseBody);
    }
  } catch (e) {
    return UploadVideoResponse(success: false, message: "Error: $e");
  }
}

}
