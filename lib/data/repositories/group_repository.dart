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

import 'package:http/http.dart' as http;
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
static  Future<Map<String, dynamic>> fetchGroupMembers(String authToken, String guid, int uid) async {
    // log(widget.guid.toString());
    try {
      final response = await http.get(
        Uri.parse('https://dev.moutfits.com/api/v1/cometchat/groups/$guid/members'),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<String> fetchedImages = (data['data'] as List)
            .map<String>((member) => member['link'] ?? 'https://default-image-url.com') // Handle null values
            .toList();

        // Check if the current user's uid is in the members list
        final isMember = (data['data'] as List).any((member) => member['uid'] == uid.toString());

        return {
          'fetchedImages': fetchedImages,
          'isMember': isMember,
        };
      } else {
        log("failed");
        throw Exception("Failed to load members");
      }
    } catch (e) {
      log("Error: $e");
      throw Exception("Error fetching members");
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
