import 'package:clique/data/models/influencer_model.dart';
import 'package:clique/data/repositories/influencer_repository.dart';
import 'package:get/get.dart';

class InfluencerViewmodel extends GetxController {
  final InfluencerRepository _userRepository = InfluencerRepository();
  var influencers = <InfluencerModel>[].obs;
  var isLoading = true.obs; // Add this line
  var error = ''.obs; // Add this line to handle errors

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  void fetchUsers() async {
    try {
      isLoading(true); // Set loading to true before fetching data
      var fetchedUsers = await _userRepository.fetchInfluencers();
      influencers.assignAll(fetchedUsers);
    } catch (e) {
      error(e.toString()); // Set the error message if something goes wrong
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false); // Set loading to false after fetching data (whether successful or not)
    }
  }
}