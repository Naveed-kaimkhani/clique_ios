import 'dart:developer';

import 'package:clique/data/models/user_registration_response.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  late SharedPreferences prefs;
  Rxn<User> user = Rxn<User>();
  var token = ''.obs;
  var userName = ''.obs;
  var uid = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    loadUserSession(); // Load session on init
  }

  void saveUserSession(
      UserRegistrationResponse response, String userName) async {
  log(response.token!);
    token.value = response.token!;
    log(userName);
    this.userName.value = userName; // Set the observable value directly
    await prefs.setString('token', response.token!);
    await prefs.setString('userName', userName);
    log("session stored");
  }

  Future<void> loadUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedUserName = prefs.getString('userName');
    final storedToken = prefs.getString('token');
    uid.value = prefs.getInt('uid') ?? 0;

    log(uid.value.toString());
    if (storedUserName != null && storedToken != null) {
      userName.value = storedUserName; // Set the observable value directly
      token.value = storedToken; // Set the observable value directly
      userName.value = storedUserName; // Set the observable value directly
      token.value = storedToken;
    }
  }

  void logout() async {
    await prefs.clear();
    user.value = null;
    token.value = '';
    userName.value = '';
    uid.value = 0;
  }

  // Direct access methods for user data from SharedPreferences
  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName') ?? '';
  }

  static Future<int> getUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('uid') ?? 0;
  }
}
