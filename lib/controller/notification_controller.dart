import 'package:get/get.dart';

class NotificationController extends GetxController {
  final RxBool isSubmissionsEnabled = false.obs;
  final RxBool isApprovalsEnabled = false.obs;
  final RxBool isFeedbackNeededEnabled = false.obs;

  void updateSubmissions(bool value) {
    isSubmissionsEnabled.value = value;
  }

  void updateApprovals(bool value) {
    isApprovalsEnabled.value = value;
  }

  void updateFeedback(bool value) {
    isFeedbackNeededEnabled.value = value;
  }
} 