import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clique/view_model/group_card_viewmodel.dart';
import 'package:clique/view/chat/chat_screen.dart';
import 'package:shimmer/shimmer.dart';

class GroupCard extends StatelessWidget {
  final GroupCardViewModel viewModel;

  const GroupCard({
    required this.viewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ResponsiveDimensions dimensions = ResponsiveDimensions(size);

    return Obx(() {
      if (viewModel.isLoading.value) {
        return _buildShimmerCard(dimensions);
      }

      if (viewModel.hasError.value) {
        return Center(child: Text(viewModel.errorMessage.value));
      }

      return _buildGroupCard(context, dimensions);
    });
  }

  Widget _buildGroupCard(BuildContext context, ResponsiveDimensions dimensions) {
    return Container(
      width: dimensions.cardWidth,
      height: dimensions.cardHeight,
      padding: EdgeInsets.only(left: dimensions.size.width * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildCardContent(dimensions),
          _buildProfileImage(dimensions),
        ],
      ),
    );
  }

  Widget _buildCardContent(ResponsiveDimensions dimensions) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildBackgroundImage(dimensions),
        _buildCardDetails(dimensions),
      ],
    );
  }

  Widget _buildBackgroundImage(ResponsiveDimensions dimensions) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      child: Image.asset(
        viewModel.backgroundImage,
        height: dimensions.cardHeight * 0.3,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCardDetails(ResponsiveDimensions dimensions) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.size.width * 0.03,
        vertical: dimensions.size.height * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: dimensions.size.height * 0.015),
          _buildGroupName(dimensions),
          SizedBox(height: dimensions.size.height * 0.005),
          _buildMemberCount(dimensions),
          SizedBox(height: dimensions.size.height * 0.015),
          _buildBottomRow(dimensions),
        ],
      ),
    );
  }

  Widget _buildGroupName(ResponsiveDimensions dimensions) {
    return Text(
      viewModel.name,
      style: TextStyle(
        fontSize: dimensions.size.width * 0.045,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMemberCount(ResponsiveDimensions dimensions) {
    return Row(
      children: [
        Icon(Icons.group, size: dimensions.size.width * 0.04, color: Colors.grey),
        SizedBox(width: dimensions.size.width * 0.01),
        Text(
          viewModel.followers,
          style: TextStyle(fontSize: dimensions.size.width * 0.035, color: Colors.grey),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildBottomRow(ResponsiveDimensions dimensions) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAvatarStack(dimensions),
        _buildActionButton(dimensions),
      ],
    );
  }

  Widget _buildAvatarStack(ResponsiveDimensions dimensions) {
    return SizedBox(
      width: dimensions.avatarStackWidth,
      child: AnimatedAvatarStack(
        height: dimensions.size.height * 0.03,
        avatars: [
          for (var n = 1; n < viewModel.memberCount + 1; n++)
            NetworkImage('https://i.pravatar.cc/150?img=$n'),
        ],
      ),
    );
  }

  Widget _buildActionButton(ResponsiveDimensions dimensions) {
    return Container(
      width: dimensions.buttonWidth,
      height: dimensions.buttonHeight,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: TextButton(
          onPressed: () => viewModel.onActionButtonPressed(),
          child: Text(
            viewModel.isMember.value ? "Message" : "Join Now",
            style: TextStyle(
              color: Colors.white,
              fontSize: dimensions.size.width * 0.032,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(ResponsiveDimensions dimensions) {
    return Positioned(
      top: dimensions.cardHeight * 0.16,
      left: dimensions.size.width * 0.03,
      child: Container(
        height: dimensions.profileImageSize,
        width: dimensions.profileImageSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: viewModel.profileImage != null
              ? DecorationImage(
                  image: NetworkImage(viewModel.profileImage!),
                  fit: BoxFit.cover,
                )
              : null,
          color: viewModel.profileImage == null ? Colors.grey[300] : null,
        ),
        child: viewModel.profileImage == null
            ? Icon(Icons.person, size: dimensions.profileImageSize * 0.6, color: Colors.grey[600])
            : null,
      ),
    );
  }

  Widget _buildShimmerCard(ResponsiveDimensions dimensions) {
    return SizedBox(
      height: dimensions.size.height * 0.20,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ShimmerGroupCard(dimensions: dimensions),
      ),
    );
  }
}

class ResponsiveDimensions {
  final Size size;
  late final double cardWidth;
  late final double cardHeight;
  late final double profileImageSize;
  late final double avatarStackWidth;
  late final double buttonWidth;
  late final double buttonHeight;

  ResponsiveDimensions(this.size) {
    cardWidth = size.width * 0.75;
    cardHeight = size.height * 0.18;
    profileImageSize = size.width * 0.11;
    avatarStackWidth = size.width * 0.3;
    buttonWidth = size.width * 0.25;
    buttonHeight = size.height * 0.043;
  }
}

class ShimmerGroupCard extends StatelessWidget {
  final ResponsiveDimensions dimensions;

  const ShimmerGroupCard({required this.dimensions, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dimensions.size.width * 0.75,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: dimensions.size.height * 0.1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: dimensions.size.width * 0.4,
                  height: 16,
                  color: Colors.white,
                ),
                SizedBox(height: 8),
                Container(
                  width: dimensions.size.width * 0.3,
                  height: 12,
                  color: Colors.white,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: dimensions.size.width * 0.3,
                      height: 24,
                      color: Colors.white,
                    ),
                    Container(
                      width: dimensions.size.width * 0.2,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}