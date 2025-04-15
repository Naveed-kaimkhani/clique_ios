import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/models/influencer_model.dart';
import 'package:clique/data/repositories/influencer_repository.dart';
import 'package:clique/view_model/influencer_viewmodel.dart';
import 'package:get/get.dart';

class FollowController extends GetxController {
  // final InfluencerRepository _followRepo = InfluencerRepository();
  
  final InfluencerRepository _followRepo = Get.find<InfluencerRepository>();
  
  final InfluencerViewmodel _influencerViewmodel = Get.find<InfluencerViewmodel>();
  final UserController _user = Get.find<UserController>();
  var isFollowing = false.obs;

  // Future<bool> toggleFollow(int userId) async {
  //   bool success = await _followRepo.followUser(userId, _user.token.value);
  //   if (success) {
  //     isFollowing.value = !isFollowing.value; // Toggle follow state

  //   return true;
  //   }
  //   return false;
  // }

  
  // Future<bool> toggleUnFollow(int userId) async {
  //   bool success = await _followRepo.unFollowUser(userId, _user.token.value);
  //   if (success) {
  //     isFollowing.value = !isFollowing.value; // Toggle follow state

  //    return true;
  //   }
    
  //   return false;
  // }



  Future<bool> toggleFollow(int userId) async {
  bool success = await _followRepo.followUser(userId, _user.token.value);
  if (success) {
    isFollowing.value = true;

    // Update the specific influencer in the list
    int index = _influencerViewmodel.influencers.indexWhere((inf) => inf.id == userId);
    if (index != -1) {
      final updated = InfluencerModel(
        id: _influencerViewmodel.influencers[index].id,
        name: _influencerViewmodel.influencers[index].name,
        email: _influencerViewmodel.influencers[index].email,
        phone: _influencerViewmodel.influencers[index].phone,
        role: _influencerViewmodel.influencers[index].role,
        profilePhoto: _influencerViewmodel.influencers[index].profilePhoto,
        coverPhoto: _influencerViewmodel.influencers[index].coverPhoto,
        followersCount: _influencerViewmodel.influencers[index].followersCount,
        postCount: _influencerViewmodel.influencers[index].postCount,
        isFollowing: true, // updated follow state
      );
      _influencerViewmodel.influencers[index] = updated;
    }

    return true;
  }
  return false;
}

Future<bool> toggleUnFollow(int userId) async {
  bool success = await _followRepo.unFollowUser(userId, _user.token.value);
  if (success) {
    isFollowing.value = false;

    // Update the specific influencer in the list
    int index = _influencerViewmodel.influencers.indexWhere((inf) => inf.id == userId);
    if (index != -1) {
      final updated = InfluencerModel(
        id: _influencerViewmodel.influencers[index].id,
        name: _influencerViewmodel.influencers[index].name,
        email: _influencerViewmodel.influencers[index].email,
        phone: _influencerViewmodel.influencers[index].phone,
        role: _influencerViewmodel.influencers[index].role,
        profilePhoto: _influencerViewmodel.influencers[index].profilePhoto,
        coverPhoto: _influencerViewmodel.influencers[index].coverPhoto,
        followersCount: _influencerViewmodel.influencers[index].followersCount,
        postCount: _influencerViewmodel.influencers[index].postCount,
        isFollowing: false, // updated follow state
      );
      _influencerViewmodel.influencers[index] = updated;
    }

    return true;
  }
  return false;
}

}
