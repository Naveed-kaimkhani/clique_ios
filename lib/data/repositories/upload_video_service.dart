import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:clique/models/upload_video_response.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UploadVideoService {
  static const String baseUrl = "https://dev.moutfits.com/api/v1/popstream/create";

  // Future<UploadVideoResponse> uploadVideo({
  //   required File thumbnail,
  //   required File video,
  //   required String userId,
  //   required String name,
  //   required String showType,
  //   required String lambdaToken,
  //   required String createdBy,
  //   required String authToken,
  // }) async {
  //   try {
  //     var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
  //     request.headers['Authorization'] = 'Bearer $authToken';

  //     request.files.add(await http.MultipartFile.fromPath('thumbnail_file', thumbnail.path));
  //     request.files.add(await http.MultipartFile.fromPath('video_file', video.path));

  //     request.fields['user_id'] = userId;
  //     request.fields['name'] = name;
  //     request.fields['show_type'] = showType;
  //     request.fields['lambda_token'] = lambdaToken;
  //     request.fields['created_by'] = createdBy;

  //     var response = await request.send();
  //     log(response.statusCode.toString());
  //     log(response.headers.toString());
  //     var responseBody = await response.stream.toBytes();
  //   //  log(responseBody.toString());
  //     // log(responseBody.body)
  //     if (response.statusCode == 200) {
  //       var responseBody = await response.stream.bytesToString();
  //       var decoded = jsonDecode(responseBody);
  //       return UploadVideoResponse.fromJson(decoded);
  //     } else {
  //       return UploadVideoResponse(success: false, message: "Upload failed with status code: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     return UploadVideoResponse(success: false, message: "Error: $e");
  //   }
  // }

  

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

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: $responseBody");

    if (response.statusCode == 200) {
      var decoded = jsonDecode(responseBody);
      return UploadVideoResponse.fromJson(decoded);
    } else {
      return UploadVideoResponse(success: false, message: responseBody);
    }
  } catch (e) {
    return UploadVideoResponse(success: false, message: "Error: $e");
  }
}

}
