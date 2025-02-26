import 'package:clique/components/clique_tab_card.dart';
import 'package:clique/components/index.dart';
import 'package:flutter/material.dart';

import '../../constants/index.dart';

class ViewAllCliqueScreen extends StatelessWidget {
  const ViewAllCliqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
              key: const ValueKey('groups_list'),
              padding: const EdgeInsets.all(10),
              itemCount: 12,
              itemBuilder: (_, index) => CliqueTabCard(
                backgroundImage: AppSvgIcons.cloth,
                profileImage: AppSvgIcons.profile,
                name: 'MenswearDog',
                followers: '1200 members',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
