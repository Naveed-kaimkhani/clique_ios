import 'package:get/get.dart';
import 'package:clique/data/models/group_model.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/repositories/group_repository.dart';

class GroupViewModel extends GetxController {
  final groupRepository = Get.find<GroupRepository>();
  final userController = Get.find<UserController>();

  final RxList<Group> groups = <Group>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGroups();
  }
Future<void> leaveGroup(String guid, int uid) async {
  isLoading.value = true;
  try {
    final success = await groupRepository.leaveGroup(guid, uid);
    if (success) {
      // Optionally refresh group list or remove group locally
      fetchGroups(); // or remove from `groups` list directly
    }
  } catch (e) {
    error.value = e.toString();
  } finally {
    isLoading.value = false;
  }
}

  Future<void> fetchGroups() async {
    isLoading.value = true;
    try {
      final fetchedGroups =
          await groupRepository.fetchGroups(userController.token.value);
      groups.value = fetchedGroups;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}