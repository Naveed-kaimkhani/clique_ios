import 'package:cached_network_image/cached_network_image.dart';
import 'package:clique/components/label_text.dart';
import 'package:clique/data/models/pop_stream_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_svg_icons.dart';

class OrganicTreatsWidget extends StatelessWidget {
  
  final PopstreamModel popstream;

  const OrganicTreatsWidget({
    required this.popstream,    
    super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
  
        ProductImageWidget(popstream: popstream, screenHeight: screenHeight, screenWidth: screenWidth),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
       
 SizedBox(
        width: screenWidth * 0.3, // Fixed width
        height: screenHeight * 0.04, // Fixed height
        child: _buildMarqueeText( popstream.name, screenWidth),
      ),
            LabelText(
              text: " \$${popstream.partyName}",
              weight: FontWeight.bold,
              fontSize: screenWidth * 0.042, // Responsive font size
            ),
          ],
        ),
        Container(
          height: screenHeight * 0.13, // Responsive height
          width: screenWidth * 0.12, // Responsive width
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Center(
            child: SvgPicture.asset(
              AppSvgIcons.bag,
              height: screenHeight * 0.03, // Responsive height
              width: screenWidth * 0.06, // Responsive width
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildMarqueeText(String text , double screenWidth) {
  return Marquee(
    text: text,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: screenWidth * 0.038,
    ),
    blankSpace: 30.0,
    velocity: 50.0,
    pauseAfterRound: Duration(seconds: 1),
    startPadding: 10.0,
  );
}
}

class ProductImageWidget extends StatelessWidget {
  const ProductImageWidget({
    super.key,
    required this.popstream,
    required this.screenHeight,
    required this.screenWidth,
  });

  final PopstreamModel popstream;
  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: popstream.consultantIds , // Handle null case
      height: screenHeight * 0.06,  // Same height
      width: screenWidth * 0.12,    // Same width
      fit: BoxFit.cover,            // Same fit
      placeholder: (context, url) =>  Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: screenHeight * 0.06,
          width: screenWidth * 0.12,
          decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(4), // Adjust as needed
          ),
        ),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.image, 
        size: screenHeight * 0.06,
        color: Colors.grey[400],
      ),
    );
  }
}
