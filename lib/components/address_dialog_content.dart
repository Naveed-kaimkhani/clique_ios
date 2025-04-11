// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:clique/utils/utils.dart';
// import 'package:clique/view_model/address_controller.dart';
// import 'package:clique/view_model/order_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';

// class AddressDialogContent extends StatelessWidget {
//   final AddressController controller = Get.put(AddressController());

//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController address1Controller = TextEditingController();
//   final TextEditingController address2Controller = TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController stateController = TextEditingController();
//   final TextEditingController countryController = TextEditingController();
//   final TextEditingController zipController = TextEditingController();

//   final OrderViewModel orderViewModel = Get.put(OrderViewModel());
//   @override
//   Widget build(BuildContext context) {
//     return Form(
    
//       key: _formKey,
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             customTextField("Address 1", address1Controller),
//             customTextField("Address 2", address2Controller),
//             customTextField("City", cityController),
//             customTextField("State Code", stateController),
//             customTextField("Country Code", countryController),
//             customTextField("ZIP Code", zipController),
//             SizedBox(height: 10),
 

//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.black, // Set the button color
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Set padding
//               ),
//   onPressed: () async {
//     // Validate country code
//     if (countryController.text.trim().length != 2) {
    
//       Utils.showCustomSnackBar("Invalid Country Code","Country code must be exactly 2 characters (e.g., US, NJ).", ContentType.failure);
//       return; // Stop further execution
//     }

//     // Set address values
//     controller.address1.value = address1Controller.text;
//     controller.address2.value = address2Controller.text;
//     controller.city.value = cityController.text;
//     controller.stateCode.value = stateController.text;
//     controller.countryCode.value = countryController.text;
//     controller.zipCode.value = zipController.text;
//   Utils.showCustomSnackBar("Info","Calculating Shipping Cost. Please Wait..", ContentType.success);
//     await controller.saveAddressToPrefs();
//     await orderViewModel.submitOrder();

//     Get.back(); // Close dialog
//   },
//   child: Text("Save Address", style: TextStyle(
//    color: Colors.white, 
//   ),),
// ),

//           ],
//         ),
//       ),
//     );
//   }

//   Widget customTextField(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
// }



import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clique/utils/utils.dart';
import 'package:clique/view_model/address_controller.dart';
import 'package:clique/view_model/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AddressDialogContent extends StatelessWidget {
  final AddressController controller = Get.put(AddressController());
  final OrderViewModel orderViewModel = Get.put(OrderViewModel());

  final _formKey = GlobalKey<FormState>();

  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  // Observable variable to track loading state
  final RxBool isLoading = false.obs;

  // @override
  // Widget build(BuildContext context) {
  //   return Form(
  //     key: _formKey,
  //     child: SingleChildScrollView(
  //       child: Column(
  //         children: [
  //           customTextField("Address 1", address1Controller, TextInputType.text),
  //           customTextField("Address 2", address2Controller, TextInputType.text),
  //           customTextField("City", cityController, TextInputType.text),
  //           customTextField("State Code", stateController, TextInputType.text),
  //           customTextField("Country Code", countryController, TextInputType.text),
  //           customTextField("ZIP Code", zipController, TextInputType.number),
  //           SizedBox(height: 10),
  //           Obx(() {
  //             return ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.black, // Set the button color
  //                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Set padding
  //               ),
  //               onPressed: isLoading.value
  //                   ? null // Disable the button while loading
  //                   : () async {
  //                       // Validate country code
  //                         if (countryController.text.isEmpty) {
  //                         Utils.showCustomSnackBar(
  //                           "Error",
  //                           "Please Enter Address.",
  //                           ContentType.warning,
  //                         );
  //                         return; // Stop further execution
  //                       }
  //                       if (countryController.text.trim().length != 2) {
  //                         Utils.showCustomSnackBar(
  //                           "Invalid Country Code",
  //                           "Country code must be exactly 2 characters (e.g., US, NJ).",
  //                           ContentType.warning,
  //                         );
  //                         return; // Stop further execution
  //                       }

  //                       // Set address values
  //                       controller.address1.value = address1Controller.text;
  //                       controller.address2.value = address2Controller.text;
  //                       controller.city.value = cityController.text;
  //                       controller.stateCode.value = stateController.text;
  //                       controller.countryCode.value = countryController.text;
  //                       controller.zipCode.value = zipController.text;
  //                       Utils.showCustomSnackBar(
  //                           "Info", "Calculating Shipping Cost. Please Wait..", ContentType.success);

  //                       // Set loading to true
  //                       isLoading.value = true;

  //                       await controller.saveAddressToPrefs();
  //                       await orderViewModel.submitOrder();

  //                       // Set loading to false after the process
  //                       isLoading.value = false;

  //                       Get.back(); // Close dialog
  //                     },
  //               child: isLoading.value
  //                   ? CircularProgressIndicator(
  //                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  //                     )
  //                   : Text(
  //                       "Save Address",
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //             );
  //           }),
  //         ],
  //       ),
  //     ),
  //   );
  // }

@override
Widget build(BuildContext context) {
  return Dialog(
    insetPadding: EdgeInsets.all(16),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customTextField("Address 1", address1Controller, TextInputType.text),
              customTextField("Address 2", address2Controller, TextInputType.text),
              customTextField("City", cityController, TextInputType.text),
              customTextField("State Code", stateController, TextInputType.text),
              customTextField("Country Code", countryController, TextInputType.text),
              customTextField("ZIP Code", zipController, TextInputType.number),
              SizedBox(height: 16),
              Obx(() {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: isLoading.value
                      ? null
                      : () async {
                          if (countryController.text.isEmpty) {
                            Utils.showCustomSnackBar(
                              "Error",
                              "Please Enter Address.",
                              ContentType.warning,
                            );
                            return;
                          }
                          if (countryController.text.trim().length != 2) {
                            Utils.showCustomSnackBar(
                              "Invalid Country Code",
                              "Country code must be exactly 2 characters (e.g., US, NJ).",
                              ContentType.warning,
                            );
                            return;
                          }

                          controller.address1.value = address1Controller.text;
                          controller.address2.value = address2Controller.text;
                          controller.city.value = cityController.text;
                          controller.stateCode.value = stateController.text;
                          controller.countryCode.value = countryController.text;
                          controller.zipCode.value = zipController.text;

                          Utils.showCustomSnackBar(
                              "Info", "Calculating Shipping Cost. Please Wait..", ContentType.success);

                          isLoading.value = true;

                          await controller.saveAddressToPrefs();
                          await orderViewModel.submitOrder();

                          isLoading.value = false;

                          Get.back();
                        },
                  child: isLoading.value
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          "Save Address",
                          style: TextStyle(color: Colors.white),
                        ),
                );
              }),
            ],
          ),
        ),
      ),
    ),
  );
}



  Widget customTextField(String label, TextEditingController controller, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child:TextFormField(
      keyboardType: type,
  controller: controller,
  decoration: InputDecoration(
    labelText: label,
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey), // Set focused border color to grey
    ),
  ),
),

    );
  }
}
