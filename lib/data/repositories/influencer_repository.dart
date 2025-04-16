import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/core/api/api_client.dart';
import 'package:clique/core/api/api_endpoints.dart';
import 'package:clique/data/models/influencer_model.dart';
import 'package:clique/data/models/update_user_model.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class InfluencerRepository {

  final String url = ApiEndpoints.getInfluencers;
  final ApiClient apiClient = Get.find<ApiClient>();
  final UserController userController = Get.find<UserController>();



    Future<bool> updateUserProfile(UpdateUserModel user, File profilePhoto, File coverPhoto) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiEndpoints.updateApi));

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer ${userController.token.value}',
        'Accept': 'application/json',
      });

      // Add fields from the user model
      request.fields.addAll(user.toJson());

      // Add profile and cover photos
      request.files.add(await http.MultipartFile.fromPath('profile_photo', profilePhoto.path));
      request.files.add(await http.MultipartFile.fromPath('cover_photo', coverPhoto.path));

      // Send the request
      var response = await request.send();

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Read the response body
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> responseData = jsonDecode(responseBody);

        // Extract values from the response
        final String userName = responseData["user"]["name"];
        final int userId = responseData["user"]["id"];
        final String role = responseData["user"]["role"];
        final String? profileImage = responseData["user"]["profile_photo_url"];
        final String? coverPhotoUrl = responseData["user"]["cover_photo_url"];
        final String email = responseData["user"]["email"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', userName);
      await prefs.setString('role', role);
      await prefs.setInt('uid', userId);
      await prefs.setString('profile_photo_url', profileImage ?? '');
      await prefs.setString('cover_photo_url', coverPhotoUrl ?? '');
      await prefs.setString('email', email);
      
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }







  Future<List<InfluencerModel>> fetchInfluencers() async {
    final response = await apiClient.getInfluencersApi( url:url, authToken: userController.token.value , params: {
        "role": "influencer",
      }, );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<InfluencerModel> users = body.map((dynamic item) => InfluencerModel.fromJson(item)).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }



    Future<bool> followUser(int userId, String token) async {
    try {
      final response = await apiClient.post(url: '${ApiEndpoints.baseUrl}/follow/$userId',
      headers: {"Content-Type": "application/json",
                  "Authorization": "Bearer $token", // Attach Bearer Token

        },
      );
      if (response.statusCode == 200) {
 
        return true; // Followed successfully
      } else {
        return false; // Failed to follow
      }
    } catch (e) {
      return false;
    }
  }

     Future<bool> unFollowUser(int userId, String token) async {
    try {
      final response = await apiClient.post(url: '${ApiEndpoints.baseUrl}/unfollow/$userId',
      headers: {"Content-Type": "application/json",
                  "Authorization": "Bearer $token", // Attach Bearer Token

        },
      );
      if (response.statusCode == 200) {
    
        return true; // Followed successfully
      } else {
        return false; // Failed to follow
      }
    } catch (e) {
      return false;
    }
  }
}