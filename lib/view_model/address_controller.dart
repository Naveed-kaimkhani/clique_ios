import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressController extends GetxController {
  var address1 = ''.obs;
  var address2 = ''.obs;
  var city = ''.obs;
  var stateCode = ''.obs;
  var countryCode = ''.obs;
  var zipCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAddressFromPrefs();
  }

  Future<void> saveAddressToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('address_1', address1.value);
    prefs.setString('address_2', address2.value);
    prefs.setString('city', city.value);
    prefs.setString('state_code', stateCode.value);
    prefs.setString('country_code', countryCode.value);
    prefs.setString('zip_code', zipCode.value);
  }

  Future<void> loadAddressFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    address1.value = prefs.getString('address_1') ?? '';
    address2.value = prefs.getString('address_2') ?? '';
    city.value = prefs.getString('city') ?? '';
    stateCode.value = prefs.getString('state_code') ?? '';
    countryCode.value = prefs.getString('country_code') ?? '';
    zipCode.value = prefs.getString('zip_code') ?? '';
  }
}
