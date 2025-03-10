import 'package:get/get.dart';

class GroupCardViewModel extends GetxController {
  final String backgroundImage;
  final String? profileImage;
  final String name;
  final String followers;
  final String guid;
  final String authToken;
  final String uid;
  final String groupName;
  final int memberCount;
  final RxBool isMember = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  GroupCardViewModel({
    required this.backgroundImage,
    this.profileImage,
    required this.name,
    required this.followers,
    required this.guid,
    required this.authToken,
    required this.uid,
    required this.groupName,
    required this.memberCount,
  });

  void onActionButtonPressed() {
    // Add your action button logic here
    
    if (isMember.value) {
      Get.toNamed('/chat', arguments: {
        'guid': guid,
        'groupName': groupName,
      });
    } else {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      try {
        // Add join group logic here
        isMember.value = true;
      } catch (e) {
        hasError.value = true;
        errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }
  }
} 