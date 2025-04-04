import 'package:clique/view_model/discover_viewmodel.dart';
import 'package:get/get.dart';
import 'package:clique/data/repositories/group_repository.dart';
import 'package:clique/utils/utils.dart';

class GroupController extends GetxController {
  // RxBool isMember = false.obs;

  final DiscoverViewModel _viewModel = Get.find<DiscoverViewModel>();
  // Fetch group membership status
  // Future<void> fetchGroupStatus(String authToken, String guid, int uid) async {
  //   try {
  //     final response = await GroupRepository.fetchGroupMembers(authToken, guid, uid);
  //     isMember.value = response['isMember'];
  //     if (isMember.value) {
  //       // Utils.saveJoinedGroup(guid);
  //     }
  //   } catch (e) {
  //     print("Error fetching group status: $e");
  //   }
  // }

  // Join group and update state
  Future<void> joinGroup(String guid, int uid) async {
    bool isAdded = await GroupRepository().joinGroup(guid, uid);
    if (isAdded) {
      // isMember.value = true;
      _viewModel.fetchGroups();
      // Utils.saveJoinedGroup(guid);
    }
  }
}
