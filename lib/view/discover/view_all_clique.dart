import 'package:clique/components/clique_tab_card.dart';
import 'package:clique/components/index.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/index.dart';
import '../../view_model/discover_viewmodel.dart';

class ViewAllCliqueScreen extends StatelessWidget {
  const ViewAllCliqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DiscoverViewModel _viewModel = Get.find<DiscoverViewModel>();
final UserController _userController = Get.find<UserController>();

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.appGradientColors,
      ),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: CustomAppBar(title: "All Cliques", icon: Icons.arrow_back_ios),
          backgroundColor: Colors.white,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Obx(() => ListView.builder(
              key: const ValueKey('groups_list'),
              padding: const EdgeInsets.all(10),
              itemCount: _viewModel.groups.length,
              itemBuilder: (_, index) => CliqueTabCard(
                guid: _viewModel.groups[index].guid,
                uid: _userController.uid.value,
                authToken: _userController.token.value,
                memberCount:_viewModel.groups[index].membersCount ,
                backgroundImage: AppSvgIcons.cloth,
                profileImage: _viewModel.groups[index].icon??"",
                name: _viewModel.groups[index].name,
                followers: '${_viewModel.groups[index].membersCount} members',
              ),
            )),
          ),
        ),
      ),
    );
  }
}


