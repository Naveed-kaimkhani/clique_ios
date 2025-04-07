import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProductCard extends StatelessWidget {
  const ShimmerProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final cardWidth = screenWidth * 0.5;
    final cardHeight = screenHeight * 0.25;
    final padding = screenWidth * 0.03;

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.only(left: padding),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              // Image placeholder
              Container(
                width: double.infinity,
                height: 276,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              // Cart Icon Placeholder
              Positioned(
                top: padding,
                right: padding,
                child: Container(
                  padding: EdgeInsets.all(padding * 0.5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.favorite_outline, color: Colors.grey),
                ),
              ),
              // Bottom content
              Positioned(
                bottom: 5,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: screenWidth * 0.035,
                        width: screenWidth * 0.3,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: padding * 0.5),
                      Container(
                        height: screenWidth * 0.03,
                        width: screenWidth * 0.5,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: screenWidth * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Price placeholder
                          Row(
                            children: [
                              Container(
                                height: screenWidth * 0.035,
                                width: screenWidth * 0.12,
                                color: Colors.grey[400],
                              ),
                              SizedBox(width: padding * 0.5),
                              Container(
                                height: screenWidth * 0.03,
                                width: screenWidth * 0.1,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                          // Discount placeholder
                          Container(
                            height: screenWidth * 0.035,
                            width: screenWidth * 0.15,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
