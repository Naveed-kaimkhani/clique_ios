import 'dart:developer';

import 'package:clique/data/models/pop_stream_model.dart';
import 'package:get/get.dart';
import 'package:clique/data/models/group_model.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/repositories/group_repository.dart';

class DiscoverViewModel extends GetxController {
  final userController = Get.find<UserController>();
  
//  final userController =    Get.put(UserController());
  final groupRepository = Get.find<GroupRepository>();
  final RxList<Group> groups = <Group>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  var userJoinedGroups = <String>[].obs; // List of groups user has joined

  RxList<PopstreamModel> popstreams = <PopstreamModel>[].obs;
  final String apiUrl = "https://clique.revovideo.net/api/popstream/get-all-popstream?language=en";
//   final String lamdaToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6Im5leHRnZW5lcmF0aW9uc2RldmVsb3BlckBnbWFpbC5jb20iLCJvcmduYW1lIjoiYWRtaW5fdXNlciIsImNyZWF0ZWRfb24iOjAsImlzcmVnaXN0ZXJlZCI6dHJ1ZX0.iRF5vN4hh9NmQbNFTuke-jygVxlbTm0TNa-FPkJR5j8"; // Securely store this
//  final String authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJuZXh0Z2VuZXJhdGlvbnNkZXZlbG9wZXJAZ21haWwuY29tIiwianRpIjoiZGRhMDljZmUtZWUxNi00ZDJhLTk4MGItYjMzOGNmYmMyNzczIiwiZXhwIjoxNzQyMzM5OTY0LCJpc3MiOiJyZXZvLmNsaXF1ZSIsImF1ZCI6InJldm8uY2xpcXVlIn0.kvFGJYOng8L4OXm05u3NJ5zCaRXVHjOVhi8y1bWzqNE"; // Securely store this

 
  @override
  void onInit() {
    super.onInit();
    fetchPopstreams();
    fetchGroups();
  }

    Future<void> fetchPopstreams() async {
       final String lamdaToken = userController.revoLamdaToken.value; // Securely store this
 final String authToken = userController.revoAccessToken.value; // Securely store this

    try {
      final response = await GetConnect().post(
        apiUrl,
        {
          "last_id": "",
          "brand_name": "clique",
          "email": "",
          "search_text": "",
          "size": 12,
          "lambda_token": "$lamdaToken"
        },
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type": "application/json",
        },
      );
      log(response.body.toString());
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        List<dynamic> popstreamList = response.body['popstreams'];
        popstreams.value = popstreamList.map((item) => PopstreamModel.fromJson(item)).toList();
      } else {
        Get.snackbar("Error", "Failed to fetch Popstreams");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  Future<void> fetchGroups() async {
    isLoading.value = true;
    try {
      final fetchedGroups = await groupRepository.fetchGroups(userController.token.value);
      groups.value = fetchedGroups;
      isLoading.value = false;
    } catch (e) {
      error.value = e.toString();
      isLoading.value = false;
    }
  }
}