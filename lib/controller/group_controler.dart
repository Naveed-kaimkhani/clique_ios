import 'package:clique/view_model/group_view_model.dart';
import 'package:get/get.dart';
import 'package:clique/data/repositories/group_repository.dart';

class GroupController extends GetxController {
  // RxBool isMember = false.obs;
RxBool isJoining = false.obs;

  final GroupViewModel _viewModel = Get.find<GroupViewModel>();

  Future<void> joinGroup(String guid, int uid) async {
    bool isAdded = await GroupRepository().joinGroup(guid, uid);
    if (isAdded) {
      isJoining.value = true;
      _viewModel.fetchGroups();
      isJoining.value = false;
    }
  }
}
