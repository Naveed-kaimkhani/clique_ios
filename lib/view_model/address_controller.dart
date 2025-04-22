

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressController extends GetxController {
  
  // final OrderViewModel orderViewModel = Get.put(OrderViewModel());
  var address1 = ''.obs;
  var address2 = ''.obs;
  var city = ''.obs;
  var stateCode = ''.obs;
  // var stateCodekiValue='';
  var countryCode = ''.obs;
  var zipCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAddressFromPrefs();
  }

  // Function to clear the saved address data
  Future<void> clearAddress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('address_1');
    await prefs.remove('address_2');
    await prefs.remove('city');
    await prefs.remove('state_code');
    await prefs.remove('country_code');
    await prefs.remove('zip_code');

    // Optionally, clear the Rx variables after removing them from SharedPreferences
    address1.value = '';
    address2.value = '';
    city.value = '';
    stateCode.value = '';
    countryCode.value = '';
    zipCode.value = '';
  }
  Future<void> saveAddressToPrefs(String stateCode, String city ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('address_1', address1.value);
    prefs.setString('address_2', address2.value);
    prefs.setString('city',city);
    prefs.setString('state_code', stateCode);
    prefs.setString('country_code', 'US');
    prefs.setString('zip_code', zipCode.value);
    loadAddressFromPrefs();
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