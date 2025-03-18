import 'package:clique/core/api/api_client.dart';
import 'package:clique/data/repositories/auth_respository.dart';
import 'package:clique/data/repositories/group_repository.dart';
import 'package:clique/data/repositories/influencer_repository.dart';
import 'package:clique/routes/app_routes.dart';
import 'package:clique/view/auth/login_screen.dart';
import 'package:clique/view/auth/signup_screen.dart';
import 'package:clique/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main() {
   Get.put(ApiClient());
  //  Get.put(AuthRepository());
  //  Get.put(GroupRepository());
  //   Get.put(InfluencerRepository());

   Get.lazyPut(()=>GroupRepository());
   
   Get.lazyPut(()=>AuthRepository());
   
   Get.lazyPut(()=>InfluencerRepository());
  //  Get.put(UserController());
  runApp(
MyApp(),
    // DevicePreview(
    //   enabled: true, // Enable DevicePreview for testing
    //   builder: (context) =>  MyApp()
    // ),
  );
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
     debugShowCheckedModeBanner: false,
        theme: ThemeData(
        fontFamily: 'SofiaPro',  // Apply font globally
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontFamily: 'SofiaPro'),
          bodySmall: TextStyle(fontFamily: 'SofiaPro'),
        ),
      ),
      home:SplashScreen(),
      // initialRoute: RouteName.homeScreen,
      getPages: AppRoutes.getAppRoutes(),
    );
  }
}