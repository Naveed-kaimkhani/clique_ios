// import 'package:clique/data/models/user_model.dart';
// import 'package:get/get.dart';
// import '../data/repositories/user_repository.dart';
// import '../core/api/api_response.dart';

// class UserViewModel extends GetxController {
//   final UserRepository _userRepo = UserRepository();
//   final Rx<ApiResponse<List<UserModel>>> users = ApiResponse<List<UserModel>>.loading().obs;

//   void fetchUsers() async {
//     try {
//       users.value = ApiResponse.loading();
//       final userList = await _userRepo.fetchUsers();
//       users.value = ApiResponse.completed(userList);
//     } catch (e) {
//       users.value = ApiResponse.error(e.toString());
//     }
//   }
// }
