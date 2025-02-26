
import 'package:clique/routes/app_routes.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:clique/view/home/home_screen.dart';
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
        fontFamily: 'SofiaPro',  // Apply font globally
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontFamily: 'SofiaPro'),
          bodySmall: TextStyle(fontFamily: 'SofiaPro'),
        ),
      ),
      home:HomeScreen(),
      
      initialRoute: RouteName.homeScreen,
      
      getPages: AppRoutes.getAppRoutes(),
    );
  }
}



