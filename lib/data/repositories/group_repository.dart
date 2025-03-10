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

      final UserController userController = Get.find<UserController>();
  /// **Join Group API Call**
  Future<bool> joinGroup(String guid, int uid ) async {
    try {
      // if (guid.isEmpty || userController.token.value == null) {
      //   throw Exception("User token not found. Please log in again.");
      // }

      final Map<String, dynamic> body = {
        "guid": guid,
        "uid": userController.uid.value.toString(),
        "scope": "participant"
      };

      final response = await apiClient.joinGroupApi(
        ApiEndpoints.joinGroup,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${userController.token.value}",
        },
        body: body,
      );
      
      return true; // Return true on successful join
          
    } catch (e) {
      Utils.showCustomSnackBar("Failed to join group",
          Utils.mapErrorMessage(e.toString()), ContentType.failure);
      throw Exception("Failed to join group: $e");
    }
  }

  /// **Fetch Groups from API**
  Future<List<Group>> fetchGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      // String token = userController.token.value;
      log(userController.token.value);
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
      // Utils.showCustomSnackBar("Failed to load groups", Utils.mapErrorMessage(e.toString()), ContentType.failure);
      throw Exception("Failed to load groups: $e");
    }
  }
}
