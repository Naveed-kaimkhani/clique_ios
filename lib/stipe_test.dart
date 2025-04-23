
import 'package:clique/view_model/stripe_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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