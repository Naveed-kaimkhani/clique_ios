import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/models/influencer_model.dart';
import 'package:clique/data/repositories/influencer_repository.dart';
import 'package:get/get.dart';

class InfluencerViewmodel extends GetxController {
  final InfluencerRepository _userRepository = InfluencerRepository();
  

  final userController = Get.find<UserController>();
  var influencers = <InfluencerModel>[].obs;
  var isLoading = true.obs; // Add this line
  var error = ''.obs; // Add this line to handle errors
  var searchQuery = ''.obs;

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }
  List<InfluencerModel> get filteredInfluencers {
    if (searchQuery.value.isEmpty) return influencers;
    return influencers
        .where((influencer) => influencer.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void fetchUsers() async {
    try {
      isLoading(true); // Set loading to true before fetching data
      var fetchedUsers = await _userRepository.fetchInfluencers();
      
      // Filter out your own user ID from the list
      var filteredUsers = fetchedUsers.where((user) => user.id != userController.uid.value).toList();
      
      influencers.assignAll(filteredUsers);
    } catch (e) {
      error(e.toString()); // Set the error message if something goes wrong
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false); // Set loading to false after fetching data
    }
  }



}