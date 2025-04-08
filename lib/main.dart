import 'package:clique/core/api/api_client.dart';
import 'package:clique/data/repositories/auth_respository.dart';
import 'package:clique/data/repositories/group_repository.dart';
import 'package:clique/data/repositories/influencer_repository.dart';
import 'package:clique/routes/app_routes.dart';
import 'package:clique/view/discover/discover_screen.dart';
import 'package:clique/view/splash/splash_screen.dart';
import 'package:clique/view/upload_product_screens/upload_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';


void main() { 
   Get.put(ApiClient());
  Get.put(GroupRepository());
  Get.put(AuthRepository());
  Get.put(InfluencerRepository());
  
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51RBMHyF2KDumDuVOylTaEasrDreMcD8OW8kuT5Qv3k7MFf055ISzIKICY8RegFrbd9HQoRFyXXe5mmjuvy5pqu7N009RT2dXt1';
  runApp(
MyApp(),
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