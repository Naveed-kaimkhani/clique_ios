import 'package:clique/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  final Function(int) onTap;
  final int selectedIndex;

  const CustomBottomNavBar({Key? key, required this.onTap, required this.selectedIndex}) : super(key: key);

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      bottom: screenHeight * 0.033, // Adjust based on screen height
      left: 0,
      right: 0,
      child: Container(
        height: screenHeight * 0.07, // Responsive height
        width: screenWidth * 0.08, // Adjust width dynamically
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.22, 
          vertical: screenHeight * 0.01
        ),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.01, 
          vertical: screenHeight * 0.01
        ),
        decoration: BoxDecoration(
            
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),

            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavItem(Icons.shopping_cart_outlined, 0),
            SizedBox(width: screenWidth * 0.01), // Responsive spacing
            _buildNavItem(Icons.explore, 1),
            SizedBox(width: screenWidth *0.01),

            _buildNavItem(Icons.group_outlined, 2),
            SizedBox(width: screenWidth *0.01),
            
            _buildNavItem(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isActive = widget.selectedIndex == index;
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        widget.onTap(index);
      },
      child: Container(
        height: screenWidth * 0.13, // Scaled size
        width: screenWidth * 0.12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isActive
              ? AppColors.appGradientColors
              : LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.white, Colors.white],
                ),
        ),
        child: Icon(icon, color: isActive ? Colors.white : Colors.grey, size: screenWidth * 0.07),
      ),
    );
  }
}
