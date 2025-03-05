import 'dart:convert';
import 'dart:developer';


import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clique/controller/user_controller.dart';

import 'package:clique/data/models/group_model.dart';
import 'package:clique/utils/utils.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';

class GroupRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  /// **Join Group API Call**
  Future<bool> joinGroup(String guid, int uid) async {
    try {
      final UserController userController = Get.find<UserController>();
      log("join group");
      log(userController.token.value);
      log(userController.uid.value.toString());
      if (userController.token.value.isEmpty || userController.token.value == null) {
        throw Exception("User token not found. Please log in again.");
      }

      final Map<String, dynamic> body = {
        "guid": guid,
        "uid": uid.toString(),
        "scope": "participant"
      };

      final response = await apiClient.post(
        ApiEndpoints.joinGroup,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${userController.token.value}",
        },
        body: body,
      );

      if (response != null && response['status'] == "success") {
        return true;
      } else {
        throw Exception(response?['message'] ?? "Failed to join group.");
      }
    } catch (e) {
      print("Error in joinGroup: $e");
      Utils.showCustomSnackBar("Failed to join group",
          Utils.mapErrorMessage(e.toString()), ContentType.failure);
      throw Exception("Failed to join group: $e");
    }
  }

  /// **Fetch Groups from API**
  Future<List<Group>> fetchGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // final token = prefs.getString('userToken') ?? '';

      // final UserController userController = Get.find<UserController>();
      // print("userController.token: ${userController.token}");
      String token = prefs.getString('token') ?? '';
      if (token.isEmpty) {
        throw Exception("User token not found. Please log in again.");
      }

      final response = await apiClient.getGroup(
        ApiEndpoints.getGroups,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

   

      // if (response == null || !response.containsKey('data')) {
      //   throw Exception("Invalid response from server");
      // }
      final decodedResponse = jsonDecode(response.body);
      return (decodedResponse['data'] as List)
          .map((group) => Group.fromJson(group))
          .toList();
    } catch (e) {
      print("Error in fetchGroups: $e");
      // Utils.showCustomSnackBar("Failed to load groups", Utils.mapErrorMessage(e.toString()), ContentType.failure);
      throw Exception("Failed to load groups: $e");
    }
  }
}
