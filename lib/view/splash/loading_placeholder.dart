import 'package:clique/constants/app_images.dart';
import 'package:flutter/material.dart';
class LoadingPlaceHolder extends StatefulWidget {
  @override
  _LoadingPlaceHolderState createState() => _LoadingPlaceHolderState();
}

class _LoadingPlaceHolderState extends State<LoadingPlaceHolder> {
  @override
  void initState() {
    super.initState();
    // _checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          AppImages.appLogo,
          width: 220,
          height: 220,
        ),
      ),
    );
  }
}
