import 'dart:developer';

import 'package:clique/core/api/api_client.dart';
import 'package:clique/core/api/api_endpoints.dart';
import 'package:clique/data/models/pop_stream_model.dart';
import 'package:get/get.dart';
import 'package:clique/data/models/group_model.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/repositories/group_repository.dart';

class DiscoverViewModel extends GetxController {
  final userController = Get.find<UserController>();

  final ApiClient apiClient = Get.find<ApiClient>();
//  final userController =    Get.put(UserController());
  final groupRepository = Get.find<GroupRepository>();
  final RxList<Group> groups = <Group>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  var userJoinedGroups = <String>[].obs; // List of groups user has joined

  RxList<PopstreamModel> popstreams = <PopstreamModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPopstreams();
    fetchGroups();
  }

  Future<void> fetchPopstreams() async {
    // final prefs =
    //     await SharedPreferences.getInstance(); // Initialize SharedPreferences
    String authToken = "";
    final String lamdaToken =
        userController.revoLamdaToken.value; // Retrieve lambda token

    try {
      // Fetch a fresh token
      final refreshResponse = await GetConnect().post(
       ApiEndpoints.revoAccessToken,
        {
          "email": userController.userEmail.value // Retrieve email
        },
      );
      // log("access token fetced");
      // log(refreshResponse.body['access_token']);
      // log("status code mila h");
      // log(refreshResponse.statusCode.toString());
      if (refreshResponse.statusCode == 200) {
        authToken = refreshResponse.body['access_token'];

        // Store the new token in SharedPreferences
        // await prefs.setString('revo_access_token', authToken);

        // // Update the token in the userController
        // userController.revoAccessToken.value = authToken;
      } else {
        Get.snackbar("Error", "Failed to refresh token");
        return;
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while refreshing token: $e");
      return;
    }

    // log("auth token");
    // log(authToken);

    // log("lamda token");
    // log(lamdaToken);

    try {
      final response = await GetConnect().post(
        ApiEndpoints.revoApiUrl,
        {
          "last_id": "",
          "brand_name": "clique",
          "email": "",
          "search_text": "",
          "size": 12,
          "lambda_token": lamdaToken,
        },
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type": "application/json",
        },
      );
      log("lamda token me issue to nh hy $lamdaToken");
      log(response.body.toString());
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        log("initialize popstrem");
        log(response.statusCode.toString());
        List<dynamic> popstreamList = response.body['popstreams'];
        popstreams.value =
            popstreamList.map((item) => PopstreamModel.fromJson(item)).toList();
      } else {
        Get.put(UserController());
        fetchPopstreams();
        // log("in else");
        // log(response.body.toString());
        // log(response.statusCode.toString());
        // Get.snackbar("Error", "Failed to fetch Popstreams");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  Future<void> fetchGroups() async {
    isLoading.value = true;
    try {
      final fetchedGroups =
          await groupRepository.fetchGroups(userController.token.value);
      groups.value = fetchedGroups;
      isLoading.value = false;
    } catch (e) {
      error.value = e.toString();
      isLoading.value = false;
    }
  }
}
