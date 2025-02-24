import 'package:clique/components/influencer_card.dart';
import 'package:clique/components/search_screen.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:clique/view/cart/cart_screen.dart';
import 'package:clique/view/cart/checkout_screen.dart';
import 'package:clique/view/chat/chat_screen.dart';
import 'package:clique/view/home/home_screen.dart';
import 'package:clique/view/notifications/notification_screen.dart';
import 'package:clique/view/product/product_details_screen.dart';
import 'package:clique/view/profile/influencer_profile.dart';
import 'package:get/get.dart';



class AppRoutes {
  static getAppRoutes() => [
    GetPage(
        name: RouteName.productDetailsScreen,
        page: () =>  ProductDetailsScreen(),
        transition: Transition.cupertino),
            GetPage(
        name: RouteName.notificationScreen,
        page: () =>  NotificationScreen(),
        transition: Transition.cupertino),
  GetPage(
        name: RouteName.homeScreen,
        page: () =>  HomeScreen(),
        transition: Transition.cupertino),

    GetPage(
        name: RouteName.checkoutScreen,
        page: () =>  CheckoutScreen(),
        transition: Transition.cupertino),
          GetPage(
        name: RouteName.influencerProfile,
        page: () =>  InfluencerProfile(),
        transition: Transition.cupertino),
  GetPage(
        name: RouteName.cartScreen,
        page: () =>  CartScreen(),
        transition: Transition.cupertino),
          GetPage(
        name: RouteName.groupChatScreen,
        page: () =>  GroupChatScreen(),
        transition: Transition.cupertino),
        //      GetPage(
        // name: RouteName.searchScreen,
        // page: () =>  SearchScreen(),
        // transition: Transition.cupertino),
  ];
}

