import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThreadScreenAppbar extends StatelessWidget {
  final String title;
  final String guid;
  final int uid;

  ThreadScreenAppbar({
    super.key,
    required this.guid,
    required this.uid,
    required this.title,
  });

  final RxBool isDeleting = false.obs;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.11,
      width: double.infinity,
      padding: EdgeInsets.only(top: size.height * 0.05),
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Centered Title
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.w700,
            ),
          ),
          // Back Button
          Positioned(
            left: 10,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: size.width * 0.07,
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
    );
  }
}
