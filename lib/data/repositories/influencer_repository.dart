import 'dart:convert';
import 'dart:developer';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/core/api/api_client.dart';
import 'package:clique/core/api/api_endpoints.dart';
import 'package:clique/data/models/influencer_model.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
class InfluencerRepository {
  // final String _baseUrl = 'https://dev.moutfits.com/api/v1/user';

  final String url = ApiEndpoints.getInfluencers;
  final ApiClient apiClient = Get.find<ApiClient>();
  final UserController userController = Get.find<UserController>();
  Future<List<InfluencerModel>> fetchInfluencers() async {
    final response = await apiClient.getInfluencersApi( url:url, authToken: userController.token.value , params: {
        "role": "influencer",
      }, );
  log(response.statusCode.toString());
  log(response.body);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<InfluencerModel> users = body.map((dynamic item) => InfluencerModel.fromJson(item)).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }
}