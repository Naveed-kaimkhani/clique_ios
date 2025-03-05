import 'package:get/get.dart';

class ChatViewModel extends GetxController {
  final RxList messages = [].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  void initChat(String guid) {
    // Initialize chat logic here
  }

  Future<void> sendMessage(String guid, String message) async {
    // Send message logic here
  }

  @override
  void dispose() {
    messages.clear();
    super.dispose();
  }
} 