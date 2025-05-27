import 'package:cached_network_image/cached_network_image.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:clique/view_model/group_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupAppBar extends StatelessWidget {
  final String title;
  final int memberCount;
  final String? profile;

  final String guid;
  final int uid;

  GroupAppBar(
      {super.key,
      required this.guid,
      required this.uid,
      required this.title,
      required this.memberCount,
      this.profile});
  final RxBool isDeleting = false.obs;
  final GroupViewModel _viewModel = Get.find<GroupViewModel>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Get screen size

    return Container(
      height: size.height * 0.11, // 12% of screen height
      width: double.infinity,
      padding: EdgeInsets.only(top: size.height * 0.03), // 4% of screen height
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.redAccent, Colors.orangeAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: Row(
        // mainAxisAlignment: Mai,
        children: [
          // Back Button
          Padding(
            padding:
                EdgeInsets.only(right: size.width * 0.01), // 4% of screen width
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: Colors.white,
                  size: size.width * 0.07), // 7% of screen width
              onPressed: () {
                Get.back();
              },
            ),
          ),

          // Profile Image and Text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: size.height * 0.055, // 6% of screen height
                width: size.height * 0.055, // 6% of screen height
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: profile != null
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(profile!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: profile == null ? Colors.grey[300] : null,
                ),
                child: profile == null
                    ? Icon(Icons.person,
                        size: size.height * 0.033, color: Colors.grey[600])
                    : null,
              ),
              SizedBox(width: size.width * 0.02), // 2% of screen width
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.045, // 4.5% of screen width
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      memberCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.04, // 4% of screen width
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Info Icon
          // Replace the Expanded widget containing the info icon with this:
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: size.width * 0.06),
                child: Container(
                  width: size.width * 0.07, // Same width as the icon would have
                  height:
                      size.width * 0.07, // Same height as the icon would have

                  // Empty container maintains the space
                  child: IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () => _showDeleteAccountDialog(context),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 320),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Warning Icon
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_rounded,
                        size: 36,
                        color: AppColors.appColor,
                      ),
                    ),

                    SizedBox(height: 16),

                    // Title
                    Text(
                      "Leave Group?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.appColor,
                      ),
                    ),

                    SizedBox(height: 12),

                    // Description
                    Text(
                      "This will remove you from the group and all associated data.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    SizedBox(height: 24),

                    // Buttons Row
                    Row(
                      children: [
                        // Cancel Button
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 12),

                        // Delete Button with Loading
                        Expanded(
                          child: Obx(() => ElevatedButton(
                                onPressed: _viewModel.isLoading.value
                                    ? null
                                    : () async {
                                        // _viewModel.isLoading.value= true;
                                        await _viewModel.leaveGroup(guid, uid);
                                        // isDeleting.value = false;
                                        Get.back(); // Instead of Navigator.pop
                                        Get.toNamed(RouteName.homeScreen);
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.appColor,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: _viewModel.isLoading.value
                                    ? SizedBox(
                                        width: 18,
                                        height: 18,
                                        child:
                                            CircularProgressIndicator.adaptive(
                                          backgroundColor: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Text(
                                        "Delete",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
