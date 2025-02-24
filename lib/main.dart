
import 'package:clique/routes/app_routes.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:clique/view/cart/checkout_screen.dart';
import 'package:clique/view/cart/confirm_payment.dart';
import 'package:clique/view/home/home_screen.dart';
import 'package:clique/view/testttttt.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
void main() {
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
        fontFamily: 'ClashDisplay',  // Apply font globally
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontFamily: 'ClashDisplay'),
          bodySmall: TextStyle(fontFamily: 'ClashDisplay'),
        ),
      ),
      home:HomeScreen(),
      
      initialRoute: RouteName.homeScreen,
      
      getPages: AppRoutes.getAppRoutes(),
    );
  }
}



