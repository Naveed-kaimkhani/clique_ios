import 'package:clique/components/index.dart';
import 'package:clique/constants/index.dart';
import 'package:clique/data/models/influencer_model.dart';
import 'package:clique/view_model/influencer_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewAllInfluencersScreen extends StatelessWidget {
  const ViewAllInfluencersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InfluencerViewmodel influencerViewModel = Get.find<InfluencerViewmodel>();

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.appGradientColors,
      ),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: CustomAppBar(title: "All Influencers", icon: Icons.arrow_back_ios),
          backgroundColor: Colors.white,
          body: _buildInfluencersGrid(context, influencerViewModel),
        ),
      ),
    );
  }

  Widget _buildInfluencersGrid(BuildContext context, InfluencerViewmodel influencerViewModel) {
    final size = MediaQuery.of(context).size;

    return Obx(() {
      if (influencerViewModel.isLoading.value) {
        return Center(child: CircularProgressIndicator()); // Show loading indicator
      }

      if (influencerViewModel.error.value.isNotEmpty) {
        return Center(child: Text(influencerViewModel.error.value)); // Show error message
      }

      if (influencerViewModel.influencers.isEmpty) {
        return Center(child: Text('No influencers available')); // Show empty state
      }

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: GridView.builder(
          key: const ValueKey('influencers_grid'),
          padding: const EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: size.width * 0.02,
            mainAxisSpacing: size.height * 0.03,
            childAspectRatio: 0.6,
          ),
          itemCount: influencerViewModel.influencers.length,
          itemBuilder: (_, index) {
            InfluencerModel influencer = influencerViewModel.influencers[index];
            return InfluencerCard(
              influencerModel: influencer,
              isFollowing: influencer.isFollowing,
            id: influencer.id,
              backgroundImage: influencer.coverPhoto ?? AppSvgIcons.cloth, // Use cover photo if available
              profileImage: influencer.profilePhoto ?? AppSvgIcons.profile, // Use profile photo if available
              name: influencer.name,
              followers: '${influencer.followersCount} Followers', // Use followers count
            );
          },
        ),
      );
    });
  }
}