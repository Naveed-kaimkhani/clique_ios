

import 'package:clique/components/custom_appbar.dart';
import 'package:clique/components/label_text.dart';
import 'package:clique/components/noti_tile.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/constants/app_images.dart';
import 'package:clique/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define responsive dimensions
    final double paddingHorizontal = screenWidth * 0.04; // 4% of screen width
    final double paddingVertical = screenHeight * 0.02; // 2% of screen height
    final double titleFontSize = screenWidth * 0.045; // 4.5% of screen width
    final double switchSize = screenWidth * 0.09; // 12% of screen width

    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          appBar:     CustomAppBar(title: "Notification", isNotification: true, icon: Icons.arrow_back_ios),
        
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
               SizedBox(height: paddingVertical),
              Expanded(child: CustomTabs()),
        
              // Notification Settings Title
              Padding(
                padding: EdgeInsets.only(left: paddingHorizontal, top: paddingVertical),
                child: Text(
                  "Notification Settings",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        
              // Notification Toggles
              Padding(
                                padding: EdgeInsets.only(left: paddingHorizontal,),

                child: _buildNotificationTile(
                  title: "Newly Upload",
                  value: controller.isSubmissionsEnabled,
                  onChanged: (val) => controller.updateSubmissions(val),
                  switchSize: switchSize,
                ),
              ),
              Padding(
                            padding: EdgeInsets.only(left: paddingHorizontal, ),

                child: _buildNotificationTile(
                  title: "Approvals",
                  value: controller.isApprovalsEnabled,
                  onChanged: (val) => controller.updateApprovals(val),
                  switchSize: switchSize,
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTile({
    required String title,
    required RxBool value,
    required Function(bool) onChanged,
    required double switchSize,
  }) {
    return Obx(
      () => ListTile(
        title: LabelText(
          text: title,
          fontSize: 14,
          weight: FontWeight.w500,
        ),
        trailing: SizedBox(
          width: switchSize,
          child: Switch(
        
            activeColor: AppColors.appColor,
            value: value.value,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

class CustomTabs extends StatefulWidget {
  const CustomTabs({super.key});

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define responsive dimensions
    final double tabBarMargin = screenWidth * 0.03; // 3% of screen width
    final double tabBarPadding = screenWidth * 0.01; // 1% of screen width
    final double tabBarIndicatorPadding = screenWidth * 0.005; // 0.5% of screen width
    final double tabBarHeight = screenHeight * 0.06; // 6% of screen height

    final List<Map<String, String>> notifications = [
      {
        'title': 'New Post Submitted',
        'message': 'Cindy has submitted a new post',
        'time': '30m'
      },
      {
        'title': 'New Feedback Needed',
        'message': 'Your team member needs your feedback',
        'time': '4h'
      },
      {
        'title': 'Post Approved',
        'message': 'Your post has been approved and is live',
        'time': '2d'
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            // Tab Bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: tabBarMargin),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.appColor.withOpacity(0.2)),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: AppColors.appGradientColors,
                  borderRadius: BorderRadius.circular(20),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicatorPadding: EdgeInsets.all(tabBarIndicatorPadding),
                padding: EdgeInsets.all(tabBarPadding),
                labelPadding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(
                    child: Container(
                      width: double.infinity,
                      height: tabBarHeight,
                      alignment: Alignment.center,
                      child:Text( "All"),
                    ),),
                  Tab(
                    child: Container(
                      width: double.infinity,
                      height: tabBarHeight,
                      alignment: Alignment.center,
                      child: Text( "Read"),
                    ),),
                ],
              ),
            ),

            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // All Notifications Tab
                  Column(
                    children: [
                      Expanded(
                        child: notifications.isEmpty
                            ? const Center(child: Text("No notifications"))
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: tabBarPadding),
                                itemCount: notifications.length,
                                itemBuilder: (context, index) {
                                  final notification = notifications[index];
                                  return NotificationTile(
                                    title: notification['title'] ?? '',
                                    message: notification['message'] ?? '',
                                    time: notification['time'] ?? '',
                                  );
                                },
                              ),
                      ),
                    ],
                  ),

                  // Read Notifications Tab
                  const Center(child: Text("No Notifications")),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}