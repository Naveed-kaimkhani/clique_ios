import 'package:get/get.dart';
import 'package:clique/data/models/group_model.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/repositories/group_repository.dart';

class InfluencerJoinedGroup extends GetxController {
  final groupRepository = Get.find<GroupRepository>();
  final userController = Get.find<UserController>();
  final RxList<Group> groups = <Group>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchGroups();
  }

  Future<void> fetchGroups(int id) async {
    isLoading.value = true;
    try {
      final fetchedGroups =
          await groupRepository.influencerJoinedGroup(userController.token.value,id);
      groups.value = fetchedGroups;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}