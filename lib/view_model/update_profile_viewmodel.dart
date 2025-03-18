import 'dart:io';
import 'package:clique/data/models/update_user_model.dart';
import 'package:clique/data/repositories/influencer_repository.dart';
import 'package:get/get.dart';

class UpdateProfileViewModel extends GetxController {
  // final ApiService apiService;

  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString phone = ''.obs;
  File? profilePhoto;
  File? coverPhoto;
  RxBool isLoading = false.obs;

  // UpdateProfileViewModel(this.apiService);

  final InfluencerRepository _userRepository = InfluencerRepository();
  Future<bool> updateUserProfile(String token) async {
    if (profilePhoto == null || coverPhoto == null) {
      Get.snackbar("Error", "Please select profile and cover photos");
      return false;
    }

    isLoading.value = true;

    UpdateUserModel user = UpdateUserModel(
      name: name.value,
      email: email.value,
      phone: phone.value,
      profilePhoto: profilePhoto!.path,
      coverPhoto: coverPhoto!.path,
    );

    bool success = await _userRepository.updateUserProfile(user, profilePhoto!, coverPhoto!,);
    isLoading.value = false;

    if (success) {
      Get.snackbar("Success", "Profile updated successfully");
    } else {
      Get.snackbar("Error", "Failed to update profile");
    }

    return success;
  }

  void pickImage(File image, bool isProfile) {
    if (isProfile) {
      profilePhoto = image;
    } else {
      coverPhoto = image;
    }
    update();
  }
}
