import 'package:clique/components/custom_appbar.dart';
import 'package:clique/components/post_card.dart';
import 'package:clique/components/profile_card.dart';
import 'package:clique/components/profile_product_card.dart';
import 'package:flutter/material.dart';

class InfluencerProfile extends StatefulWidget {
  @override
  State<InfluencerProfile> createState() => InfluencerProfileState();
}

class InfluencerProfileState extends State<InfluencerProfile> {
  final PageController controller = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
         color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(title: 'Profile', icon: Icons.arrow_back_ios,),
                SizedBox(height: size.height * 0.02), // Responsive spacing
        ProfileCard(isInfluencer: true,),
          
                // SizedBox(height: size.height * 0.02), // Responsive spacing
                // Center(
                //   child: CustomButton(
                //     text: 'Edit Profile',
                //     onTap: () {
                             
                //     },
                //   ),
                // ),
        
                SizedBox(height: size.height * 0.02), // Responsive spacing
                     DefaultTabController(
                  length: 2,  // Number of tabs
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TabBar(
                        indicatorColor: Colors.black,  // Customize the indicator color
                        labelColor: Colors.black,      // Active tab label color
                        unselectedLabelColor: Colors.grey,  // Inactive tab label color
                        tabs: const [
                          Tab(
                            child: Text(
                              'Posts',
                              style: TextStyle(
                                fontSize: 18,           // Set font size
                                fontWeight: FontWeight.bold, // Make the text bold
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Products',
                              style: TextStyle(
                                fontSize: 18,           // Set font size
                                fontWeight: FontWeight.bold, // Make the text bold
                              ),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 10),
        
                      // TabBarView for content
                      SizedBox(
                        height: size.height * 0.7, // Responsive height for TabView
                        child: TabBarView(
                          children: [
                            
                         ListView(
                           children: [
                               PostWidget(),
                                  PostWidget(),
                           ], 
                         ),
                              Padding(
                      
                                padding: const EdgeInsets.only(top: 12.0),
                                child: ListView(
                                                           children: [
                                    ProfileProductCard(
                                      uid: '1',
                                                backgroundImage: 'assets/png/product.png',
                                                productName: "Girl’s Full Blazers",
                                                productDescription: "Crafted from premium, breathable cotton fabric",
                                                price: 53.23,
                                                oldPrice: 100.23,
                                                discount: "10% OFF",
                                              ),
                                  ProfileProductCard(
                                    uid: '2',
                                                backgroundImage: 'assets/png/product2.png',
                                                productName: "Girl’s Full Blazers",
                                                productDescription: "Crafted from premium, breathable cotton fabric",
                                                price: 53.23,
                                                oldPrice: 100.23,
                                                discount: "10% OFF",
                                              ),
                                                           ], 
                                                         ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

