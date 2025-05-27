import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/models/group_model.dart';
import 'package:clique/utils/utils.dart';
import 'package:get/get.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import 'package:http/http.dart' as http;

class GroupRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  final UserController userController = Get.find<UserController>();

  /// **Join Group API Call**
  Future<bool> joinGroup(String guid, int uid) async {
    try {
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

  static Future<Map<String, dynamic>> fetchGroupMembers(
      String authToken, String guid, int uid) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://cactisocial.com/api-clique/public/api/v1/cometchat/groups/$guid/members'),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<String> fetchedImages = (data['data'] as List)
            .map<String>((member) =>
                member['link'] ??
                'https://default-image-url.com') // Handle null values
            .toList();

        // Check if the current user's uid is in the members list
        final isMember = (data['data'] as List)
            .any((member) => member['uid'] == uid.toString());

        return {
          'fetchedImages': fetchedImages,
          'isMember': isMember,
        };
      } else {
        throw Exception("Failed to load members");
      }
    } catch (e) {
      throw Exception("Error fetching members");
    }
  }

  Future<bool> leaveGroup(String guid, int uid) async {
    final String apiUrl =
        "https://269435d754e8fd97.api-US.cometchat.io/v3/groups/$guid/members/$uid";

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          "apiKey": "f6985bc6a317824cc687e82794955efded6bf2b1",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data']['success'] == true) {
          Utils.showCustomSnackBar(
            "Success",
            "Group left successfully",
            ContentType.success,
          );
          return true;
        } else {
          throw Exception(data['data']['message']);
        }
      } else {
        throw Exception(
            "Failed to leave group. Status: ${response.statusCode}");
      }
    } catch (e) {
      Utils.showCustomSnackBar("Error", e.toString(), ContentType.failure);
      return false;
    }
  }

  /// **Fetch Groups from API**
  Future<List<Group>> influencerJoinedGroup(String token, int uid) async {
    try {
      final response = await apiClient.getGroup(
        "https://cactisocial.com/api-clique/public/api/v1/cometchat/groups?uid=$uid",
        headers: {
          'Authorization': 'Bearer ${userController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      final decodedResponse = jsonDecode(response.body);
      return (decodedResponse['data'] as List)
          .map((group) => Group.fromJson(group))
          .toList();
    } catch (e) {
      // Utils.showCustomSnackBar("Failed to load groups", Utils.mapErrorMessage(e.toString()), ContentType.failure);
      throw Exception("Failed to load groups: $e");
    }
  }

  Future<List<Group>> fetchGroups(String token) async {
    try {
      final response = await apiClient.getGroup(
        ApiEndpoints.getGroups,
        headers: {
          'Authorization': 'Bearer ${userController.token.value}',
          'Content-Type': 'application/json',
        },
      );

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
