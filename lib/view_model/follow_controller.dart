import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/repositories/influencer_repository.dart';
import 'package:clique/view_model/influencer_viewmodel.dart';
import 'package:get/get.dart';

class FollowController extends GetxController {
  // final InfluencerRepository _followRepo = InfluencerRepository();
  
  final InfluencerRepository _followRepo = Get.find<InfluencerRepository>();
  
  final InfluencerViewmodel _influencerViewmodel = Get.find<InfluencerViewmodel>();
  final UserController _user = Get.find<UserController>();
  var isFollowing = false.obs;

  Future<bool> toggleFollow(int userId) async {
    bool success = await _followRepo.followUser(userId, _user.token.value);
    if (success) {
      isFollowing.value = !isFollowing.value; // Toggle follow state
   _influencerViewmodel.fetchUsers();
    return true;
    }
    return false;
  }

  
  Future<bool> toggleUnFollow(int userId) async {
    bool success = await _followRepo.unFollowUser(userId, _user.token.value);
    if (success) {
      isFollowing.value = !isFollowing.value; // Toggle follow state
_influencerViewmodel.fetchUsers();
     return true;
    }
    
    return false;
  }
}
