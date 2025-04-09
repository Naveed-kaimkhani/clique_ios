import 'package:clique/view_model/group_view_model.dart';
import 'package:clique/view_model/stripe_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Stripetest extends StatelessWidget {
   Stripetest({super.key});

  final StripeViewModel _groupViewModel = Get.put(StripeViewModel());
  @override
  Widget build(BuildContext context) {
    return  Scaffold

    (
backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(onPressed: (){
                _groupViewModel.makePayment(100.0);
            }, child: Text("pay now")),
          )
        ],
      ),
    );
  }
}