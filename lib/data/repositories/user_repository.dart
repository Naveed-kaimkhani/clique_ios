// import 'package:clique/data/models/user_model.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';

// import '../../core/api/api_client.dart';
// import '../../core/api/api_endpoints.dart';

// class UserRepository {
//   final ApiClient apiClient = Get.find<ApiClient>();

//   Future<List<User>> fetchUsers() async {
//     try {
//       final response = await apiClient.get(ApiEndpoints.users);
//       return (response as List).map((e) => User.fromJson(e)).toList();
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }
// }
