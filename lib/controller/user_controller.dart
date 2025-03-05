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
  }

  void saveUserSession(
      UserRegistrationResponse response, String userName) async {
    print("yahn issue arha hy");
    // user.value = response.user;
    token.value = response.token!;
    // await prefs.setString('user', response.user!.toJson());
    await prefs.setString('token', response.token!);
    await prefs.setString('userName', userName);
    // await prefs.setString('uid', uid);
    loadUserSession();
    print("session stored");
  }

  void loadUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedUserName = prefs.getString('userName');
    final storedToken = prefs.getString('token');

    uid.value = prefs.getInt('uid') ?? 0;

    print("fsdfsdfsdfdsfffffffffffff\n");
    print("storedUserName: $storedUserName");
    print("storedToken: $storedToken");
    if (storedUserName != null && storedToken != null) {
      userName.value = storedUserName;
      token.value = storedToken;

    }
  }

  void logout() async {
    await prefs.clear();
    user.value = null;
    token.value = '';
  }
}
