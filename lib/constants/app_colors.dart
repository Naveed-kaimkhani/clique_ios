import 'package:flutter/material.dart';

class AppColors {
  static LinearGradient appGradientColors = LinearGradient(
            begin: Alignment.centerLeft, // 270 degrees
            end: Alignment.centerRight,
            colors: [
              Color(0xFFFE7736), // Orange
              Color(0xFFF50E50), // Reddish Pink
            ],
  );
  static LinearGradient backGradientColors = LinearGradient(
            begin: Alignment.centerLeft, // 270 degrees
            end: Alignment.centerRight,
            colors: [
             Colors.black, // Orange
            Colors.black, // Reddish Pink
            ],
  );
              // Light Blue
               // Golden Yellow
  static const appColor =  Color(0xFFF94643);
  
    static const LinearGradient blackgroundGradient = LinearGradient(
    colors: [
      Color(0xFFF4F7FB), // #F4F7FB (100% opacity)
      Color(0xD8F4F7FB), // rgba(244, 247, 251, 0.845192) (~85% opacity)
      Color(0x00F4F7FB), // rgba(244, 247, 251, 0) (0% opacity)
      Color(0xB9F4F7FB), // rgba(244, 247, 251, 0.724163) (~72% opacity)
      Color(0xFFF4F7FB), // #F4F7FB (100% opacity)
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.2379, 0.4902, 0.7474, 1.0], // Gradient stops
  );
static const grey = Colors.grey
; // New background color
  static const black =  Colors.black;
  static const yellow = Color(0xFFE0B23A);
  static final mediumPink =  Colors.pinkAccent.withOpacity(0.4);
}