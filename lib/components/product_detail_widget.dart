
import 'package:clique/components/gradient_text.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/controller/size_selector.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProductDetailsWidget extends StatelessWidget {
  const ProductDetailsWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
                        // padding: EdgeInsets.all(size.width * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Girl's Full Blazers",
                              style: TextStyle(
                                fontSize: size.width * 0.08,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                              
                            SizedBox(height: size.height * 0.006),
                              
                            Row(
                              children: [
                                GradientText(
                                  "\$53.23",
                                  gradient: AppColors.appGradientColors,
                                  fontSize: size.width * 0.06,
                                ),
                                SizedBox(width: size.width * 0.02),
                                Text(
                                  "\$100.23",
                                  style: TextStyle(
                                    fontSize: size.width * 0.05,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                              
                            SizedBox(height: size.height * 0.01),
                              
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors.orange, size: size.width * 0.05),
                                SizedBox(width: size.width * 0.01),
                                Text(
                                  "4.9 (321 Reviews)",
                                  style: TextStyle(
                                    fontSize: size.width * 0.04,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                              
                            SizedBox(height: size.height * 0.01),
                              
                            Text(
                              "Crafted from premium, breathable cotton fabric",
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                color: Colors.grey,
                              ),
                            ),
                              
                            SizedBox(height: size.height * 0.01),
                            
                            GradientText(
                              "Read More>>",
                              gradient: AppColors.appGradientColors,
                              fontSize: size.width * 0.04,
                            ),
                              
                            SizedBox(height: size.height * 0.015),
                              
                            SizeSelector(),
                              
                            SizedBox(height: size.height * 0.02),
                              
                            Center(
                              child: SizedBox(
                                width: size.width * 0.8,
                                height: size.height * 0.064,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Get.toNamed(RouteName.cartScreen);
                                  },
                                  icon: Icon(Icons.shopping_cart, color: Colors.white),
                                  label: Text(
                                    "Add to Cart",
                                    style: TextStyle(
                                      fontSize: size.width * 0.04,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding:
                                        EdgeInsets.symmetric(vertical: size.height * 0.02),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
  }
}
